#include "cpuinfo.h"
#include <QFile>
#include <QString>
#include <QStringList>
#include <QDebug>

#define CPU_INFO_FILE "/proc/stat"

CpuInfo::CpuInfo()
{
    /*
    QStringList query = sometext.split(rx);
    ifstream myfile (CPU_INFO_FILE);
    if (myfile.is_open())
    {
        // Read first line and close the file again...
        if(!getline(myfile, line))
            return;

        myfile.close();

        istringstream iss(line);
        do
        {
            string sub;
            iss >> sub;
            cout << "Substring: " << sub << endl;
        } while (iss);


    }
    */
}

void CpuInfo::generateCpuLoad()
{
    qDebug() << "Called generateCpuLoad";
}
