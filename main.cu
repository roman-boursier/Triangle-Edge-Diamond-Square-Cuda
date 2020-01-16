#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "functions.cuh"
#include <math.h>
#include <opencv2/opencv.hpp>

using namespace cv;

int main(int argc, char ** argv){
	
	/*----------INIT---------------------*/

	//Mode arg
	char *mode;
	mode = (char *) malloc(strlen(argv[1])+1);
	strcpy(mode, argv[1]);
	char cpu[4] = "cpu";
	char gpu[4] = "gpu";

	//N arg
	int n = atoi(argv[2]);

	//Filename arg
	char *filename;
	filename = (char *) malloc(strlen(argv[3])+1);
	strcpy(filename, argv[3]);

	int matDim = pow(2,n) + 1;
	int nbMatEl = matDim * matDim;
	unsigned char *data, *devData, *tabDepth, *devTabDepth;
	int4 *_tabParents, *dev_tabParents;
	
	/*Init data*/
	data = (unsigned char *) calloc(matDim * matDim, sizeof *data);
	data[0] = data[matDim - 1] = data[ (matDim - 1) * matDim] = data[matDim*matDim - 1] = 1;
    data[matDim / 2 * matDim + matDim / 2] = 255;

	/*-------------CPU MODE--------------------*/

	if(strcmp(mode,cpu) == 0){
		//initTime();

		diamontCPU(matDim, matDim, data);

		//Img
		Mat img(matDim, matDim, CV_8UC1, Scalar(0));
		for(int y = 0; y < matDim; y ++){
			for(int x = 0; x < matDim; x ++){
				img.at<uchar>(y,x) = data[y * matDim + x];
			}
		}
		//makprintf("%d\t%F\n", n, getTime());

		cv::imwrite(filename, img);
	}

	/*-------------GPU MODE--------------------*/

	if(strcmp(mode,gpu) == 0){

		/*mat profondeur*/
		tabDepth = (unsigned char *) calloc(matDim * matDim, sizeof *tabDepth);
		_tabParents = (int4 *) calloc(matDim * matDim, sizeof *_tabParents);
		tabDepth[0] = tabDepth[matDim - 1] = tabDepth[(matDim - 1) * matDim] = tabDepth[matDim * matDim-1] = 0;

		_tabParents[0].x = _tabParents[matDim - 1].x = _tabParents[(matDim - 1) * matDim].x = _tabParents[matDim * matDim-1].x = -1;
		_tabParents[0].y = _tabParents[matDim - 1].y = _tabParents[(matDim - 1) * matDim].y = _tabParents[matDim * matDim-1].y = -1;
		_tabParents[0].z = _tabParents[matDim - 1].z = _tabParents[(matDim - 1) * matDim].z = _tabParents[matDim * matDim-1].z = -1;
		_tabParents[0].w = _tabParents[matDim - 1].w = _tabParents[(matDim - 1) * matDim].w = _tabParents[matDim * matDim-1].w = -1;
		//tabDepth[matDim / 2 * matDim + matDim / 2] = 9;
		/*Remplissage mat de parents et profondeur*/
		initArrays(tabDepth, _tabParents, matDim, matDim);

		/*Affichage profondeur*/
		char matProfName[] = "profondeur";
		displayMat(tabDepth, matProfName, matDim);	
		//Img output

		Mat img(matDim, matDim, CV_8UC1);
		const int grayBytes = img.step * img.rows;
		unsigned char *d_input, *d_img;
		cudaMalloc(&d_img, nbMatEl* sizeof grayBytes);
		cudaMemcpy(d_input, img.ptr(), grayBytes, cudaMemcpyHostToDevice);

		cudaMalloc(&devData, nbMatEl* sizeof *devData);
		cudaMalloc(&devTabDepth, nbMatEl* sizeof *devTabDepth);
		cudaMalloc(&dev_tabParents, nbMatEl* sizeof *dev_tabParents);
		
		cudaMemcpy(devData, data, nbMatEl* sizeof *data, cudaMemcpyHostToDevice);
		cudaMemcpy(devTabDepth, tabDepth, nbMatEl* sizeof *tabDepth, cudaMemcpyHostToDevice);
		cudaMemcpy(dev_tabParents, _tabParents, nbMatEl* sizeof *_tabParents, cudaMemcpyHostToDevice);
		
		
		int _maxProf = maxProf(tabDepth, matDim);

		int th = _maxProf;
		printf("%d", _maxProf);
		dim3 dimBlock(th, th, 1);
		dim3 dimGrid((matDim / dimBlock.x)+1, (matDim / dimBlock.y)+1, 1);
		
		//initTime();
		for(int i = 1; i<=_maxProf; i++){
			diamontImg<<<dimGrid, dimBlock, 0>>>(devData, d_img, devTabDepth, dev_tabParents, i, matDim);
		}

		cudaMemcpy(data, devData, nbMatEl* sizeof *data, cudaMemcpyDeviceToHost);
		cudaMemcpy(img.ptr(), d_img, grayBytes, cudaMemcpyDeviceToHost);

		cv::imwrite(filename, img);
	}

	// char matDatasName[] = "datas";
	// displayMat(data, matDatasName, matDim);

	cudaFree(devData); free(data);
	cudaFree(devTabDepth); free(tabDepth);
	
	return 0;
}