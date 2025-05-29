#include "editsession.h"
#include "ui_editsession.h"
#include <QSqlQuery>

editsession::editsession(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::editsession)
{
    ui->setupUi(this);
}

editsession::~editsession()
{
    delete ui;
}

void editsession::setClientPLaceData(int clientId, int placeId, QTime sessionStart, QTime sessionEnd)
{
    // клиенты
    QSqlQuery clientQuery("SELECT id, name FROM client");

    while (clientQuery.next()) {
        int id = clientQuery.value(0).toInt();
        QString name = clientQuery.value(1).toString();
        ui->Client->addItem(name, id);  // именно editsession::ui
    }

    // игровые места
    QSqlQuery placeQuery("SELECT id, type FROM gaming_place");

    while (placeQuery.next()) {
        int id = placeQuery.value(0).toInt();
        QString type = placeQuery.value(1).toString();
        ui->Place->addItem(QString("№%1 (%2)").arg(id).arg(type), id); //♥ 💥 id в data!
    }

    int clientIndex = ui->Client->findData(clientId);
    int placeIndex = ui->Place->findData(placeId);

    if(clientIndex>= 0)
    {
        ui->Client->setCurrentIndex(clientIndex);
    }
    if(placeIndex>= 0)
    {
        ui->Place->setCurrentIndex(placeIndex);
    }

    ui->SessionStart->setTime(sessionStart);
    ui->SessionEnd->setTime(sessionEnd);
}

int editsession::getClientId() const
{
    return ui->Client->currentData().toInt();
}

int editsession::getPlaceId() const
{
    return ui->Place->currentData().toInt();
}

QTime editsession::getSessionStart() const
{
    return ui->SessionStart->time();
}

QTime editsession::getSessionEnd() const
{
    return ui->SessionEnd->time();
}
