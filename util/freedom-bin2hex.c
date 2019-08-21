/*
 * freedom-bin2hex.c
 *
 *  Created on: 18 Aug 2019
 *      Author: carsteng
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define ARRAY_SIZE 1024

void help() {
	printf("Convert a binary file to a format that can be read in verilog via $readmemh().\n");
	printf("By default read from stdin and write to stdout using a bit width of 8.\n");
	printf("\n");
	printf("freedom-bin2hex [--help|-h] [--bit-width|-w INT] [--input|-i BIN] [--output|-o HEX]\n");
}

void dump(FILE* output_stream, int byte_width, int byte_array[]) {
	for (int i = byte_width - 1; i >= 0; i--) {
		fprintf(output_stream, "%02x", byte_array[i]);
	}
	fprintf(output_stream, "\n");
}

int main(int argc, char **argv) {

	int bit_width = 8;
	FILE* input_stream = stdin;
	FILE* output_stream = stdout;

	for (int i = 0; i < argc; i++) {
		if ((strcmp(argv[i], "--help") == 0) || (strcmp(argv[i], "-h") == 0)) {
			help();
			return 0;
		}
		if ((strcmp(argv[i], "--bit-width") == 0) || (strcmp(argv[i], "-w") == 0)) {
			if ((i + 1) == argc) {
				fprintf(stderr, "No arg for --bit-width|-w option.\n");
				return 1;
			}
			bit_width = atoi(argv[++i]);
		}
		if ((strcmp(argv[i], "--input") == 0) || (strcmp(argv[i], "-i") == 0)) {
			if ((i + 1) == argc) {
				fprintf(stderr, "No arg for --input|-i option.\n");
				return 1;
			}
			input_stream = fopen(argv[++i], "r");
		}
		if ((strcmp(argv[i], "--output") == 0) || (strcmp(argv[i], "-o") == 0)) {
			if ((i + 1) == argc) {
				fprintf(stderr, "No arg for --output|-o option.\n");
				return 1;
			}
			output_stream = fopen(argv[++i], "w");
		}
	}

	if (bit_width < 8) {
		fprintf(stderr, "Bit width cannot be negative or less than 8.\n");
		return 2;
	}
	if ((bit_width % 8) != 0) {
		fprintf(stderr, "Cannot handle non-multiple-of-8 bit width yet.\n");
		return 2;
	}
	if (bit_width > (ARRAY_SIZE * 8)) {
		fprintf(stderr, "Bit width is out of range (max supported is 8192).\n");
		return 3;
	}

	int byte_width = bit_width / 8;
	int byte_value = 0;
	int byte_count = 0;
	int byte_array[ARRAY_SIZE];

	for (int i = 0; i < byte_width; i++) {
		byte_array[i] = 0;
	}

	while ((byte_value = fgetc(input_stream)) != EOF) {
		byte_array[byte_count++] = byte_value;
		if (byte_count == byte_width) {
			byte_count = 0;
			dump(output_stream, byte_width, byte_array);
			for (int i = 0; i < byte_width; i++) {
				byte_array[i] = 0;
			}
		}
	}

	if (byte_count > 0) {
		dump(output_stream, byte_width, byte_array);
	}

	return 0;
}
