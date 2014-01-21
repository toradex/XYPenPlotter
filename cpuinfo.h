#ifndef CPUINFO_H
#define CPUINFO_H

#include <QObject>
#include <QTimer>

class CpuInfo : public QTimer
{
    Q_OBJECT
public:
    CpuInfo(QObject *parent = 0);
    void generateCpuLoad();
    Q_INVOKABLE float getCpuLoad();

private:
    void refreshCpuTicks();

    long totalTicks = 0;
    long idle = 0;
    float cpuLoad = 0;
private slots:
    void tick();
};

#endif // CPUINFO_H
