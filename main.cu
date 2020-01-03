#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "functions.cuh"
#include <math.h>

extern int matDim;

int main(int argc, char ** argv){
	
	/*----------INIT---------------------*/
	char *mode;
	mode = (char *) malloc(strlen(argv[1])+1);
	strcpy(mode, argv[1]);
	char cpu[4] = "cpu";
	char gpu[4] = "gpu";

	int n = atoi(argv[2]);
	int matDim = pow(2,n) + 1;
	int nbMatEl = matDim * matDim;;
	unsigned char *data, *devData, *tabDepth, *devTabDepth;
	int4 *_tabParents, *dev_tabParents;
	
	/*Init data*/
	data = (unsigned char *) calloc(matDim * matDim, sizeof *data);
	data[0] = data[matDim - 1] = data[ (matDim - 1) * matDim] = data[matDim*matDim - 1] = 1;
    data[matDim / 2 * matDim + matDim / 2] = matDim / 2 + 1;

	/*-------------CPU MODE--------------------*/

	if(strcmp(mode,cpu) == 0){
		initTime();
		diamontCPU(matDim, matDim, data);
		printf("%d\t time cpu : %F\n", nbMatEl, getTime());
	}

	/*-------------GPU MODE--------------------*/

	if(strcmp(mode,gpu) == 0){

		/*mat profondeur*/
		tabDepth = (unsigned char *) calloc(matDim * matDim, sizeof *tabDepth);
		_tabParents = (int4 *) calloc(matDim * matDim, sizeof *_tabParents);
		tabDepth[0] = tabDepth[matDim - 1] = tabDepth[(matDim - 1) * matDim] = tabDepth[matDim * matDim-1] = 0;

		/*Remplissage mat de parents et profondeur*/
		initArrays(tabDepth, _tabParents, matDim, matDim);

		/*Affichage profondeur*/
		// char matProfName[] = "profondeur";
		// displayMat(tabDepth, matProfName, matDim);	

		cudaMalloc(&devData, nbMatEl* sizeof *devData);
		cudaMalloc(&devTabDepth, nbMatEl* sizeof *devTabDepth);
		cudaMalloc(&dev_tabParents, nbMatEl* sizeof *dev_tabParents);

		cudaMemcpy(devData, data, nbMatEl* sizeof *data, cudaMemcpyHostToDevice);
		cudaMemcpy(devTabDepth, tabDepth, nbMatEl* sizeof *tabDepth, cudaMemcpyHostToDevice);
		cudaMemcpy(dev_tabParents, _tabParents, nbMatEl* sizeof *_tabParents, cudaMemcpyHostToDevice);
		
		int _maxProf = maxProf(tabDepth, matDim);
		printf("Max %d\n", _maxProf);

		int th = _maxProf;
		dim3 dimBlock(th, th, 1);
		dim3 dimGrid((matDim / dimBlock.x)+1, (matDim / dimBlock.y)+1, 1);
		
		initTime();
		for(int i = 0; i<=_maxProf; ++i){
			diamont<<<dimGrid, dimBlock, 0>>>(devData, devTabDepth, dev_tabParents, i, matDim);
		}
		printf("%d\t time gpu : %F\n", nbMatEl, getTime());

		cudaMemcpy(data, devData, nbMatEl* sizeof *data, cudaMemcpyDeviceToHost);
	}

	// char matDatasName[] = "datas";
    // displayMat(data, matDatasName, matDim);
	
	return 0;
}