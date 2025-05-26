#include "editsession.h"
#include "ui_editsession.h"

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
