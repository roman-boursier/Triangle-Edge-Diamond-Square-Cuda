#include <stdio.h>
#include <stdlib.h>

bool IN(int x, int y, int w, int h) {
	return (x) >= 0 && (y) >= 0 && (x) < (w) && (y) < (h);
}

int maxProf(unsigned char * arr, int matDim){
	int max_value = 0;

	for (int i = 0; i < matDim; ++i) {
		if (arr[i] > max_value)
			max_value = arr[i];
	}

	return max_value;
}

void displayMat(unsigned char * arr, char * name, int matDim){
	printf("Matrice de %s \n \n", name);
	for(int y = 0; y < matDim; ++y){
    	for(int x = 0; x < matDim; ++x){
        	printf("%d ", (int)arr[y * matDim + x]);
      	}
		printf("\n");
	}
	printf("\n");	
}

void initArrays(unsigned char * _tabDepth, int4 * _tabParents, int w, int h) {
	int sw1 = w - 1, sw2 = sw1 >> 1;
	int sh1 = h - 1, sh2 = sh1 >> 1;
	int niveau = 1;
	while(sw2){
		for(int y = sh2; y < h; y += sh1){
			for(int x = sw2; x < w; x += sw1){
				if(_tabDepth[y * w + x]) continue;
				_tabDepth[y * w + x] = niveau;
				_tabParents[y * w + x].x = (y - sh2) * w + x - sw2;
 				_tabParents[y * w + x].y = (y - sh2) * w + x + sw2;
 				_tabParents[y * w + x].z = (y + sh2) * w + x + sw2;
				_tabParents[y * w + x].w = (y + sh2) * w + x - sw2;
 			}

		}
		niveau++; 
		for(int y = 0; y < h; y += sh1){
			for(int x = sw2; x < w; x += sw1){
				int yp, xp;
				if(_tabDepth[y * w + x]) continue;
				yp = y - sh2; xp = x; // parent haut
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].x = yp * w + xp;
				} else{
					_tabParents[y * w + x].x = -1;
				}
				yp = y; xp = x + sw2; // parent droit
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].y = yp * w + xp;
				} else{
					_tabParents[y * w + x].y = -1;
				}
				yp = y + sh2; xp = x; // parent bas
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].z = yp * w + xp;
				} else{
					_tabParents[y * w + x].z = -1;
				}
				yp = y; xp = x - sw2; // parent gauche
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].w = yp * w + xp;
				} else{
					_tabParents[y * w + x].w = -1;
				}
				_tabDepth[y * w + x] = niveau;
 			}
			
		}
		for(int y = sh2; y < h; y += sh1){
			for(int x = 0; x < w; x += sw1){
				int yp, xp;
				if(_tabDepth[y * w + x]) continue;
				yp = y - sh2; xp = x; // parent haut
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].x = yp * w + xp;
				} else{
					_tabParents[y * w + x].x = -1;
				}
				yp = y; xp = x + sw2; // parent droit
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].y = yp * w + xp;
				} else{
					_tabParents[y * w + x].y = -1;
				}
				yp = y + sh2; xp = x; // parent bas
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].z = yp * w + xp;
				} else{
					_tabParents[y * w + x].z = -1;
				}
				yp = y; xp = x - sw2; // parent gauche
				if(IN(xp, yp, w, h)){
					_tabParents[y * w + x].w = yp * w + xp;
				} else{
					_tabParents[y * w + x].w = -1;
				}
				_tabDepth[y * w + x] = niveau;
 			}
			
		}
		niveau ++;
		sw1 = sw2;
		sw2 >>= 1;
		sh1 = sh2;
		sh2 >>= 1;
	}
}

void diamontCPU(int w, int h, unsigned char * data) {
	int sw1 = w - 1, sw2 = sw1 >> 1;
	int sh1 = h - 1, sh2 = sh1 >> 1;

	while(sw2){
		for(int y = sh2; y < h; y += sh1){
			for(int x = sw2; x < w; x += sw1){
				if(data[y * w + x]) continue;

				data[y * w + x] = (data[(y - sh2) * w + x - sw2] +
				data[(y - sh2) * w + x + sw2] +
				data[(y + sh2) * w + x + sw2] +
				data[(y + sh2) * w + x - sw2]) >> 2;
 			}
		}

		for(int y = 0; y < h; y += sh1){
			for(int x = sw2; x < w; x += sw1){
				int yp, xp;
				int nbp = 0, v = 0;

				if(data[y * w + x]) continue;
				yp = y - sh2; xp = x; // parent haut
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}

				yp = y; xp = x + sw2; // parent droit
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}
				yp = y + sh2; xp = x; // parent bas
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}
				yp = y; xp = x - sw2; // parent gauche
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				} 
				data[y * w + x] = v / nbp;
 			}	
		}
		for(int y = sh2; y < h; y += sh1){
			for(int x = 0; x < w; x += sw1){
				int yp, xp;
				int nbp = 0, v = 0;

				if(data[y * w + x]) continue;
				yp = y - sh2; xp = x; // parent haut
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}
				yp = y; xp = x + sw2; // parent droit
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}
				yp = y + sh2; xp = x; // parent bas
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}

				yp = y; xp = x - sw2; // parent gauche
				if(IN(xp, yp, w, h)){
					++nbp;
					v += data[yp * w + xp] ;
				}
				data[y * w + x] = v / nbp;
 			}
			
		}
		sw1 = sw2;
		sw2 >>= 1;
		sh1 = sh2;
		sh2 >>= 1;
	}
}

__global__ void diamont(unsigned char * data, unsigned char * tabDepth, int4 * _tabParents, int i, int tailleTab) {
	int thx = blockIdx.x * blockDim.x + threadIdx.x;
	int thy = blockIdx.y * blockDim.y + threadIdx.y;
	int ThId = thy * tailleTab + thx;
	int nbPar = 0;

	if(tabDepth[ThId] == i  && i != 1) {

		if(_tabParents[ThId].x != -1) nbPar ++;
		if(_tabParents[ThId].y != -1) nbPar ++;
		if(_tabParents[ThId].z != -1) nbPar ++;
		if(_tabParents[ThId].w != -1) nbPar ++;
		
		data[ThId] = (data[_tabParents[ThId].x] + data[_tabParents[ThId].y] + data[_tabParents[ThId].z] + data[_tabParents[ThId].w]);
		
		(nbPar == 0) ? data[ThId] = 1 : data[ThId] /= nbPar;
	}
}