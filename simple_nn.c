// define layer size
#define INPUT_SIZE 2
#define HIDDEN_SIZE 1
#define OUTPUT_SIZE 1

// ReLU activation function
float relu(float x) {
    return (x > 0) ? x : 0;
}

// simple pseudorandom number generator
unsigned int seed = 12345;
unsigned int simple_rand() {
    seed = seed * 1103515245 + 12345;
    return (seed / 65536) % 32768;
}

// init weights using generator
void init_weights(float *weights, int size) {
    for (int i = 0; i < size; i++) {
        // Generate values between -1 and 1
        weights[i] = ((float)(simple_rand() % 2000) / 1000.0f) - 1.0f;
    }
}

// entry point function
void neural_network_forward() {
    // example input vector
    float input[INPUT_SIZE] = {1.0f, 0.5f};
    
    // output arrays for each layer
    float hidden[HIDDEN_SIZE] = {0};
    float output[OUTPUT_SIZE] = {0};

    // weights for connections between layers
    float weights_input_hidden[INPUT_SIZE][HIDDEN_SIZE];
    float weights_hidden_output[HIDDEN_SIZE][OUTPUT_SIZE];

    // init weights
    init_weights(&weights_input_hidden[0][0], INPUT_SIZE * HIDDEN_SIZE);
    init_weights(&weights_hidden_output[0][0], HIDDEN_SIZE * OUTPUT_SIZE);

    // compute activations for hidden layer
    for (int j = 0; j < HIDDEN_SIZE; j++) {
        float sum = 0.0f;
        for (int i = 0; i < INPUT_SIZE; i++) {
            sum += input[i] * weights_input_hidden[i][j];
        }
        hidden[j] = relu(sum);
    }

    // compute activations for output layer
    for (int k = 0; k < OUTPUT_SIZE; k++) {
        float sum = 0.0f;
        for (int j = 0; j < HIDDEN_SIZE; j++) {
            sum += hidden[j] * weights_hidden_output[j][k];
        }
        output[k] = relu(sum);
    }

    // would normally print here, but can't with no stdio.h
    // instead, ensure compiler doesn't optimise calculations
    volatile float result = output[0];
}

// for bare-metal compilation
void _start() {
    neural_network_forward();
    
    // infinite loop acts as exit
    while(1);
}
