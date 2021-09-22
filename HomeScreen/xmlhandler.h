#ifndef XMLHANDLER_H
#define XMLHANDLER_H
#include <QtXml>
#include <QString>
#include <QFile>
#include <QList>
#include <QIODevice>
#include <QTextStream>
#include "applicationsmodel.h"

class XmlHandler :public QObject
{
    Q_OBJECT
public:
    explicit XmlHandler(QObject *parent = nullptr);
    bool ReadXQmlFile(QString filePath);
    void PaserXml(ApplicationsModel &model);
    Q_INVOKABLE void saveData(QList< QList<QString> > listData);

private:
    QString m_filePath;
    QDomDocument m_xmlDoc; //The QDomDocument class represents an XML document.


};

#endif // XMLHANDLER_H
