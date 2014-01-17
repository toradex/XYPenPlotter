#ifndef CPUINFO_H
#define CPUINFO_H

#include <QObject>

class CpuInfo : public QObject
{
public:
    CpuInfo();
    void generateCpuLoad();
};

#endif // CPUINFO_H
