#ifndef FUNC_H
#define FUNC_H
    int maxProf(unsigned char * arr, int matDim);
    void displayMat(unsigned char * arr, char * name, int matDim);
    void diamontCPU(int w, int h, unsigned char * data);
    void initArrays(unsigned char * _tabDepth, int4 * _tabParents, int w, int h);
    bool IN(int x, int y, int w, int h);
    __global__ void diamont(unsigned char * data, unsigned char * tabDepth, int4 * _tabParents, int i, int matDim);
    __global__ void diamontImg(unsigned char * data, unsigned char *img, unsigned char * tabDepth, int4 * _tabParents, int i, int matDim);
    void initTime(void);  
    double getTime(void);
#endif
