#ifndef FUNC_H
#define FUNC_H
    int maxProf(unsigned char * arr, int matDim);
    void displayMat(unsigned char * arr, char * name, int matDim);
    void initArrays(unsigned char * _tabDepth, int4 * _tabParents, int w, int h);
    bool IN(int x, int y, int w, int h);
    __global__ void diamont(unsigned char * data, unsigned char * tabDepth, int4 * _tabParents, int i, int matDim);
#endif
