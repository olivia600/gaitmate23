#include <Wire.h>
#include <math.h>

#define DELTA_T         0.1 //s
#define DATASET_NUM     50 // Number of data sets
#define DATA_NUM        9 // Number of data in each set
#define ITER_STEP       1e-5
#define ITER_CNT        100

#define VECTOR_SIZE 3
#define MATRIX_SIZE 2

/*************************************Global Parameters*************************************/
float params_axis[4] = {0.5, 0.5, 0.5, 0.5};
float params_pos[6] = {0.1, 0.1, 0.1, 0.1, 0.1, 0.1};
float j1[3], j2[3];
float o1[3], o2[3];
float g1[3], g2[3];
float g_dot1[3], g_dot2[3];
float a1[3], a2[3];
float **imu_raw_data_1;
float **imu_raw_data_2;
float **imu_raw_data_online1;
float **imu_raw_data_online2;
float prev_angle_gyr, prev_angle_acc_gyr;

/****************************************Functions******************************************/

// Function to get data from IMU sensor
float **getData() {
    float acc[NUM][3];
    float vel[NUM][3];
    float vel_dot[NUM][3];
    float **raw_data = new float *[NUM];
    for (int i = 0; i < NUM; i++) {
        raw_data[i] = new float[DATA_NUM];
    }

    Serial.println("Waiting for data from USB mass storage...");

    // Simulate reading data from USB port
    for (int i = 0; i < NUM && Serial.available(); i++) {
        float addr, time, tepo;
        int hx, hy, hz;

        // Read data from the USB port
        while (Serial.available()) {
            char c = Serial.read();
            if (c == '\n') {
                break;
            }
        }

        // Read the remaining data
        Serial >> std::hex >> addr >> time >> acc[i][0] >> acc[i][1] >> acc[i][2] >> vel[i][0] >> vel[i][1] >> vel[i][2] >>
            raw_data[i][6] >> raw_data[i][7] >> raw_data[i][8] >> angle_x >> angle_y >> angle_z >> tepo >> hx >> hy >> hz;

        // Calculate velocity derivative
        for (int j = 0; j < 3; j++) {
            if (i > 1) {
                vel_dot[i][j] = (vel[i - 2][j] - 8 * vel[i - 1][j] + 8 * vel[i + 1][j] - vel[i + 2][j]) / 12 * DELTA_T;
            } else {
                vel_dot[i][j] = (8 * vel[i + 1][j] - vel[i + 2][j]) / 12 * DELTA_T;
            }
        }

        // Merge data into raw_data array
        int k = 0;
        for (int j = 0; j < 3; j++) {
            raw_data[i][k] = acc[i][j];
            raw_data[i][k + 3] = vel[i][j];
            raw_data[i][k + 6] = vel_dot[i][j];
            k++;
        }
    }

    Serial.println("Data received from USB mass storage.");

    return raw_data;
}

void get_raw_data() {
    char imu_filename_1[] = "rawdata1.txt";
    char imu_filename_2[] = "rawdata2.txt";

    imu_raw_data_1 = getData(imu_filename_1, DATASET_NUM);
    imu_raw_data_2 = getData(imu_filename_2, DATASET_NUM);
}

void get_pos(const float input[][DATA_NUM], const float params[], float output[]) {
    float o1x = params[0];
    float o1y = params[1];
    float o1z = params[2];
    float o2x = params[3];
    float o2y = params[4];
    float o2z = params[5];

    for (int i = 0; i < DATA_NUM; i++) {
        float acc_joint1_x = input[i][4] * (input[i][3] * o1y - input[i][4] * o1x) - input[i][5] * (input[i][5] * o1x - input[i][3] * o1z) + (input[i][7] * o1z - input[i][8] * o1y);
        float acc_joint1_y = input[i][5] * (input[i][4] * o1z - input[i][5] * o1y) - input[i][3] * (input[i][3] * o1y - input[i][4] * o1x) + (input[i][8] * o1x - input[i][6] * o1z);
        float acc_joint1_z = input[i][3] * (input[i][5] * o1x - input[i][3] * o1z) - input[i][4] * (input[i][4] * o1z - input[i][5] * o1y) + (input[i][6] * o1y - input[i][7] * o1x);

        float acc_joint2_x = input[i][13] * (input[i][12] * o2y - input[i][13] * o2x) - input[i][14] * (input[i][14] * o2x - input[i][12] * o2z) + (input[i][16] * o2z - input[i][17] * o2y);
        float acc_joint2_y = input[i][14] * (input[i][13] * o2z - input[i][14] * o2y) - input[i][12] * (input[i][12] * o2y - input[i][13] * o2x) + (input[i][17] * o2x - input[i][15] * o2z);
        float acc_joint2_z = input[i][12] * (input[i][14] * o2x - input[i][12] * o2z) - input[i][13] * (input[i][13] * o2z - input[i][14] * o2y) + (input[i][15] * o2y - input[i][16] * o2x);

        output[i] = sqrt(
                       pow((input[i][0] - acc_joint1_x), 2) + pow((input[i][1] - acc_joint1_y), 2) + pow((input[i][2] - acc_joint1_z), 2)
                   ) -
                   sqrt(
                       pow((input[i][9] - acc_joint2_x), 2) + pow((input[i][10] - acc_joint2_y), 2) + pow((input[i][11] - acc_joint2_z), 2)
                   );
    }
}

void get_axis(const float input[][DATA_NUM], const float params[], float output[]) {
    float theta_1 = params[0];
    float theta_2 = params[1];
    float phi_1 = params[2];
    float phi_2 = params[3];

    for (int i = 0; i < DATA_NUM; i++) {
        float term1 = input[i][1] * sin(theta_1) - input[i][2] * cos(phi_1) * sin(theta_1);
        float term2 = input[i][2] * cos(phi_1) * cos(theta_1) - input[i][0] * sin(phi_1);
        float term3 = input[i][0] * cos(phi_1) * sin(theta_1) - input[i][1] * cos(phi_1) * cos(theta_1);

        float norm1 = sqrt(pow(term1, 2) + pow(term2, 2) + pow(term3, 2));

        float term4 = input[i][4] * sin(theta_2) - input[i][5] * cos(phi_2) * sin(theta_2);
        float term5 = input[i][5] * cos(phi_2) * cos(theta_2) - input[i][3] * sin(phi_2);
        float term6 = input[i][3] * cos(phi_2) * sin(theta_2) - input[i][4] * cos(phi_2) * cos(theta_2);

        float norm2 = sqrt(pow(term4, 2) + pow(term5, 2) + pow(term6, 2));

        output[i] = norm1 - norm2;
    }
}

void get_jacobian(void (*func_ptr)(const float[][DATA_NUM], const float[], float[]),
                  const float input[][DATA_NUM],
                  const float params[],
                  float output[][DATA_NUM]) {

    int m = DATA_NUM; // Assuming DATA_NUM is the number of rows in input matrix
    int n = sizeof(params) / sizeof(params[0]); // Assuming params is a fixed-size array

    float out0[DATA_NUM];
    float out1[DATA_NUM];
    float param0[n];
    float param1[n];

    for (int j = 0; j < n; j++) {
        memcpy(param0, params, n * sizeof(float));
        memcpy(param1, params, n * sizeof(float));

        param0[j] -= ITER_STEP;
        param1[j] += ITER_STEP;

        func_ptr(input, param0, out0);
        func_ptr(input, param1, out1);

        for (int i = 0; i < m; i++) {
            output[i][j] = (out1[i] - out0[i]) / (2 * ITER_STEP);
        }
    }
}

void gauss_newton(void (*func_ptr)(const float[][DATA_NUM], const float[], float[]),
                  const float input[][DATA_NUM],
                  const float output[],
                  float params[]) {

    int m = DATA_NUM; // Assuming DATA_NUM is the number of rows in input matrix
    int n = sizeof(params) / sizeof(params[0]); // Assuming params is a fixed-size array

    float jmat[DATA_NUM][n];
    float r[DATA_NUM];
    float tmp[DATA_NUM];

    float pre_mse = 0.0;
    float mse;

    for (int i = 0; i < ITER_CNT; i++) {
        mse = 0.0;
        func_ptr(input, params, tmp);

        for (int k = 0; k < m; k++) {
            r[k] = output[k] - tmp[k];
        }

        get_jacobian(func_ptr, input, params, jmat);

        // Mean Squared Error
        mse = 0.0;
        for (int k = 0; k < m; k++) {
            mse += r[k] * r[k];
        }
        mse /= m;

        if (fabs(mse - pre_mse) < 1e-8) {
            break;
        }
        pre_mse = mse;

        // Parameter update
        float delta[n];
        for (int j = 0; j < n; j++) {
            delta[j] = 0.0;
            for (int k = 0; k < m; k++) {
                delta[j] += jmat[k][j] * r[k];
            }
            delta[j] *= ITER_STEP / mse;
            params[j] += delta[j];
        }

        Serial.print("i = ");
        Serial.print(i);
        Serial.print(", mse ");
        Serial.println(mse);
    }

    Serial.print("params: ");
    for (int j = 0; j < n; j++) {
        Serial.print(params[j]);
        Serial.print(" ");
    }
    Serial.println();
}

int imu_joint_pos_data_fit() {
    const int numImus = 2;
    const int numParams = 6;

    float input[DATASET_NUM][numImus * DATA_NUM];
    float output[DATASET_NUM];

    for (int i = 0; i < DATASET_NUM; i++) {
        int k = 0;
        for (int j = 0; j < DATA_NUM; j++) {
            input[i][k] = imu_raw_data_1[i][j];
            k++;
        }
        for (int j = 0; j < DATA_NUM; j++) {
            input[i][k] = imu_raw_data_2[i][j];
            k++;
        }
        output[i] = 0;
    }

    float params_pos[numParams] = {0.1, 0.1, 0.1, 0.1, 0.1, 0.1};
    gauss_newton(get_pos, input, output, params_pos);

    float o1[3] = {params_pos[0], params_pos[1], params_pos[2]};
    float o2[3] = {params_pos[3], params_pos[4], params_pos[5]};

    return 0;
}

int imu_joint_axis_data_fit() {
    const int numImus = 2;
    const int numParams = 4;

    float input[DATASET_NUM][numImus * 3];  // Assuming imu_raw_data_1 and imu_raw_data_2 are float arrays
    float output[DATASET_NUM];

    for (int i = 0; i < DATASET_NUM; i++) {
        int k = 0;
        for (int j = 3; j < 6; j++) {
            input[i][k] = imu_raw_data_1[i][j];
            k++;
        }
        for (int j = 3; j < 6; j++) {
            input[i][k] = imu_raw_data_2[i][j];
            k++;
        }
        output[i] = 0;
    }

    float params_axis[numParams] = {0.5, 0.5, 0.5, 0.5};
    gauss_newton(get_axis, input, output, params_axis);

    float j1[3] = {cos(params_axis[2]) * cos(params_axis[0]), cos(params_axis[2]) * sin(params_axis[0]), sin(params_axis[2])};
    float j2[3] = {cos(params_axis[3]) * cos(params_axis[1]), cos(params_axis[3]) * sin(params_axis[1]), sin(params_axis[3])};

    return 0;
}

float get_angle_acc(float j1[], float j2[],
                    float a1[], float a2[],
                    float g1[], float g2[],
                    float g_dot1[], float g_dot2[],
                    float o1[], float o2[]) {

    float c[VECTOR_SIZE] = {1, 0, 0};
    float x1[VECTOR_SIZE], x2[VECTOR_SIZE], y1[VECTOR_SIZE], y2[VECTOR_SIZE];
    float a1_dot[VECTOR_SIZE], a2_dot[VECTOR_SIZE];

    float p1, p2, q1, q2;
    float angle_acc;

    // Calculate o1 and o2
    for (int i = 0; i < VECTOR_SIZE; i++) {
        o1[i] = o1[i] - j1[i] * (o1[0] * j1[0] + o1[1] * j1[1] + o1[2] * j1[2] + o2[0] * j2[0] + o2[1] * j2[1] + o2[2] * j2[2]) / 2;
        o2[i] = o2[i] - j2[i] * (o1[0] * j1[0] + o1[1] * j1[1] + o1[2] * j1[2] + o2[0] * j2[0] + o2[1] * j2[1] + o2[2] * j2[2]) / 2;
    }

    for (int i = 0; i < VECTOR_SIZE; i++) {
        a1_dot[i] = a1[i] - (g1[i] * (g1[0] * o1[0] + g1[1] * o1[1] + g1[2] * o1[2]) - g_dot1[i] * o1[i]);
        a2_dot[i] = a2[i] - (g2[i] * (g2[0] * o2[0] + g2[1] * o2[1] + g2[2] * o2[2]) - g_dot2[i] * o2[i]);
    }

    // Calculate cross products
    crossProduct(j1, c, x1);
    crossProduct(j1, x1, y1);
    crossProduct(j2, c, x2);
    crossProduct(j2, x2, y2);

    // Calculate dot products
    p1 = dotProduct(a1_dot, x1, VECTOR_SIZE);
    p2 = dotProduct(a1_dot, y1, VECTOR_SIZE);
    q1 = dotProduct(a2_dot, x2, VECTOR_SIZE);
    q2 = dotProduct(a2_dot, y2, VECTOR_SIZE);

    // Calculate angle
    float acc1[MATRIX_SIZE] = {p1, p2};
    float acc2[MATRIX_SIZE] = {q1, q2};

    angle_acc = acos(dotProduct(acc1, acc2, MATRIX_SIZE) / (vectorNorm(acc1, MATRIX_SIZE) * vectorNorm(acc2, MATRIX_SIZE)));

    return angle_acc;
}

void crossProduct(float a[], float b[], float result[]) {
    result[0] = a[1] * b[2] - a[2] * b[1];
    result[1] = a[2] * b[0] - a[0] * b[2];
    result[2] = a[0] * b[1] - a[1] * b[0];
}

float dotProduct(float a[], float b[], int size) {
    float result = 0;
    for (int i = 0; i < size; i++) {
        result += a[i] * b[i];
    }
    return result;
}

float vectorNorm(float vector[], int size) {
    float norm = 0;
    for (int i = 0; i < size; i++) {
        norm += vector[i] * vector[i];
    }
    return sqrt(norm);
}

void test_angle() {
    float angle_acc, angle_gyr, angle_acc_gyr;
    float sum = 0;
    int cnt = 0;
    float lambda = 0.01;

    // Initialize arrays
    float a1[3], a2[3], g1[3], g2[3], g_dot1[3], g_dot2[3];

    // for test
    char imu_dataonline1[] = "rawdata_online1.txt";
    char imu_dataonline2[] = "rawdata_online2.txt";
    float **imu_raw_data_online1 = getData(imu_dataonline1, 500);
    float **imu_raw_data_online2 = getData(imu_dataonline2, 500);

    // File handling
    FILE *fp = fopen("data.txt", "w");
    if (fp == NULL) {
        Serial.println("File cannot open");
        exit(0);
    }

    for (int i = 0; i < 500; i++) {
        cnt++;

        // Assign values from arrays
        for (int k = 0; k < 3; k++) {
            a1[k] = imu_raw_data_online1[i][k];
            a2[k] = imu_raw_data_online2[i][k];
            g1[k] = imu_raw_data_online1[i][k + 3];
            g2[k] = imu_raw_data_online2[i][k + 3];
            g_dot1[k] = imu_raw_data_online1[i][k + 6];
            g_dot2[k] = imu_raw_data_online2[i][k + 6];
        }

        angle_acc = get_angle_acc(j1, j2, a1, a2, g1, g2, g_dot1, g_dot2, o1, o2);

        sum = sum + g1[0] * j1[0] + g1[1] * j1[1] + g1[2] * j1[2] - g2[0] * j2[0] - g2[1] * j2[1] - g2[2] * j2[2];

        if (cnt > 3) {
            // Calculate angle based on gyroscope data
            angle_gyr = sum * DELTA_T;

            // Complementary filter to fuse accelerometer and gyroscope angles
            angle_acc_gyr = lambda * angle_acc + (1 - lambda) * (prev_angle_acc_gyr + angle_gyr - prev_angle_gyr);
            Serial.print("angle: ");
            Serial.println(angle_acc_gyr);

            cnt = 0;

            // Write data to file
            fprintf(fp, "%f\n", angle_acc_gyr);
        }

        // Update data
        prev_angle_acc_gyr = angle_acc_gyr;
        prev_angle_gyr = angle_gyr;
    }

    fclose(fp);
}

void setup() {
    Serial.begin(9600); // Initialize serial communication
    get_raw_data();
    imu_joint_axis_data_fit();
    imu_joint_pos_data_fit();
    o1[0] = o1[0] - j1[0] * (o1[0] * j1[0] + o2[0] * j2[0]) / 2;
    o1[1] = o1[1] - j1[1] * (o1[1] * j1[1] + o2[1] * j2[1]) / 2;
    o1[2] = o1[2] - j1[2] * (o1[2] * j1[2] + o2[2] * j2[2]) / 2;
    o2[0] = o2[0] - j2[0] * (o1[0] * j1[0] + o2[0] * j2[0]) / 2;
    o2[1] = o2[1] - j2[1] * (o1[1] * j1[1] + o2[1] * j2[1]) / 2;
    o2[2] = o2[2] - j2[2] * (o1[2] * j1[2] + o2[2] * j2[2]) / 2;
}

void loop() {
    test_angle();
    // Example: Read data from USB and print to Serial
    float **data = getData();
    for (int i = 0; i < NUM; i++) {
        for (int j = 0; j < DATA_NUM; j++) {
            Serial.print(data[i][j]);
            Serial.print(" ");
        }
        Serial.println();
    }
    // Free allocated memory
    for (int i = 0; i < NUM; i++) {
        delete[] data[i];
    }
    delete[] data;
    delay(5000); // Delay for 5 seconds before reading again
}
