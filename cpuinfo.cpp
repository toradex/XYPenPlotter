#include "cpuinfo.h"

#include <iostream>
#include <QFile>
#include <QString>
#include <QStringList>
#include <QDebug>

#define CPU_INFO_FILE "/proc/stat"

CpuInfo::CpuInfo(QObject *parent)
    : QTimer(parent)
{
    refreshCpuTicks();
    connect(this, SIGNAL(timeout()), this, SLOT(tick()));
    setInterval(500);
    start();
}

void CpuInfo::tick()
{
    long totalTicksOld = totalTicks;
    long idleOld = idle;
    refreshCpuTicks();

    cpuLoad = (float)(idle - idleOld) * 100 / (totalTicks - totalTicksOld);
    cpuLoad = 100 - cpuLoad;
}

void CpuInfo::refreshCpuTicks( )
{
    QFile file(CPU_INFO_FILE);
    QTextStream in(&file);
    if(!file.open(QIODevice::ReadOnly))
        return;

    QString line = in.readLine();
    file.close();

    QStringList query = line.split(" ", QString::SkipEmptyParts);

    // Parse cpu stats, these are cpu ticks
    // in this order: user, nice, system, idle, iowait, irq, softirq
    totalTicks = 0;
    for (int i = 0; i < query.size(); i++) {
        totalTicks += query.at(i).toInt();
    }
    idle = query.at(4).toInt();
}

void CpuInfo::generateCpuLoad()
{
    qDebug() << "Called generateCpuLoad";
}

float CpuInfo::getCpuLoad()
{
    return cpuLoad;
}
