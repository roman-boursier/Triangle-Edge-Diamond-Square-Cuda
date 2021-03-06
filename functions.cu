#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

static struct timeval ti;

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

void initArraysDs(unsigned char * _tabDepth, int4 * _tabParents, int w, int h) {
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

void initArraysTe(unsigned char * _tabDepth, int4 * _tabParents, int x0, int y0, int stride, int sx, int sy, int p) {
	int w_2 = sx >> 1, h_2 = sy >> 1, j;
    int x[9] = { x0, x0 + sx, x0 + sx,
    x0, x0 + w_2, x0 + sx, x0 + w_2,
    x0, x0 + w_2 };
    int y[9] = { y0,
    y0, y0 + sy, y0 + sy,
    y0, y0 + h_2, y0 + sy, y0 + h_2, y0 + h_2 };

    for(int i = 0, i1 = 1; i < 4; ++i, i1 = (i1 + 1) % 4) {
		if(_tabDepth[j = y[i + 4] * stride + x[i + 4]]) continue;
			//Parents			
			_tabParents[j].x = y[i] * stride + x[i];
			_tabParents[j].y = y[i1] * stride + x[i1];
			_tabParents[j].z = -1;
			_tabParents[j].w = -1;
			//prof
			_tabDepth[j] = p;
        }

		if(!_tabDepth[j = y[8] * stride + x[8]]) {
            for(int i = 0; i < 4; ++i) {
				//prof
				_tabDepth[j] = p;
				//Tab parent
				if(i == 1){
					_tabParents[j].x = y[i] * stride + x[i];
				} else if(i == 2){
					_tabParents[j].y = y[i] * stride + x[i];
				} else if(i == 3) {
					_tabParents[j].z = y[i] * stride + x[i];
				} else {
					_tabParents[j].w = y[i] * stride + x[i];
				}
			}
			
        }
        if(w_2 > 1) {
            initArraysTe(_tabDepth, _tabParents, x[0], y[0], stride, w_2, h_2, ++p);
            initArraysTe(_tabDepth, _tabParents, x[4], y[4], stride, w_2, h_2, p);
            initArraysTe(_tabDepth, _tabParents, x[8], y[8], stride, w_2, h_2, p);
            initArraysTe(_tabDepth, _tabParents, x[7], y[7], stride, w_2, h_2, p);
    }
}

void triangleEdgeCPU(unsigned char * data, int x0, int y0, int stride, int sx, int sy, int p) {
	int niveau = 1;
	
    int w_2 = sx >> 1, h_2 = sy >> 1, j;
    int x[9] = { x0, x0 + sx, x0 + sx,
    x0, x0 + w_2, x0 + sx, x0 + w_2,
    x0, x0 + w_2 };
    int y[9] = { y0,
    y0, y0 + sy, y0 + sy,
    y0, y0 + h_2, y0 + sy, y0 + h_2, y0 + h_2 };

    for(int i = 0, i1 = 1; i < 4; ++i, i1 = (i1 + 1) % 4) {
        if(data[j = y[i + 4] * stride + x[i + 4]]) continue;
            data[j] = ((int)data[y[i] * stride + x[i]] +
            data[y[i1] * stride + x[i1]]) >> 1;
        }
        if(!data[j = y[8] * stride + x[8]]) {
            int v = 0;
            for(int i = 0; i < 4; ++i)
            v += data[y[i] * stride + x[i]];
            data[j] = v >> 2;
        }
        if(w_2 > 1) {
            triangleEdgeCPU(data, x[0], y[0], stride, w_2, h_2, ++p);
            triangleEdgeCPU(data, x[4], y[4], stride, w_2, h_2, p);
            triangleEdgeCPU(data, x[8], y[8], stride, w_2, h_2, p);
            triangleEdgeCPU(data, x[7], y[7], stride, w_2, h_2, p);
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

__global__ void generateImg(unsigned char * data, unsigned char * img, unsigned char * tabDepth, int4 * _tabParents, int i, int tailleTab) {
	int thx = blockIdx.x * blockDim.x + threadIdx.x;
	int thy = blockIdx.y * blockDim.y + threadIdx.y;
	int ThId = thy * tailleTab + thx;
	int nbPar = 0;

	if(data[ThId] == 0 && tabDepth[ThId] == i  && i != 1) {
	
		if(_tabParents[ThId].x != -1) nbPar ++;
		if(_tabParents[ThId].y != -1) nbPar ++;
		if(_tabParents[ThId].z != -1) nbPar ++;
		if(_tabParents[ThId].w != -1) nbPar ++;
		
		data[ThId] = (data[_tabParents[ThId].x] + data[_tabParents[ThId].y] + data[_tabParents[ThId].z] + data[_tabParents[ThId].w]) / nbPar;

		img[ThId] = data[ThId];
	}
	
}

void initTime(void) {
    gettimeofday(&ti, (struct timezone*) 0);
}

double getTime(void) {
    struct timeval t;
    double diff;
    gettimeofday(&t, (struct timezone*) 0);
    diff = (t.tv_sec - ti.tv_sec) * 1000000
    + (t.tv_usec - ti.tv_usec);
    return diff/1000.;
}