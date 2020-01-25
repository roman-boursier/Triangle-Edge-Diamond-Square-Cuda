#ifndef FUNC_H
#define FUNC_H
    int maxProf(unsigned char * arr, int matDim);
    void displayMat(unsigned char * arr, char * name, int matDim);
    void diamontCPU(int w, int h, unsigned char * data);
    void triangleEdgeCPU(unsigned char * data, int x0, int y0, int stride, int sx, int sy, int p);
    void initArraysDs(unsigned char * _tabDepth, int4 * _tabParents, int w, int h);
    void initArraysTe(unsigned char * _tabDepth, int4 * _tabParents, int x0, int y0, int stride, int sx, int sy, int p);
    bool IN(int x, int y, int w, int h);
    __global__ void generateImg(unsigned char * data, unsigned char *img, unsigned char * tabDepth, int4 * _tabParents, int i, int matDim);
    void initTime(void);  
    double getTime(void);
#endif
