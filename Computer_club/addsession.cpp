#include "addsession.h"
#include "ui_addsession.h"

addsession::addsession(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::addsession)
{
    ui->setupUi(this);
    load_data();
}

addsession::~addsession()
{
    delete ui;
}

void addsession::load_data()
{
    //клиенты
    QSqlQuery clientQuery("SELECT id, name FROM client");

    while(clientQuery.next())
    {
        int id = clientQuery.value(0).toInt();
        QString name = clientQuery.value(1).toString();
        ui->Client->addItem(name, id);
    }

    //игровые места
    QSqlQuery placeQuery("SELECT id, type FROM gaming_place");

    while(placeQuery.next())
    {
        int id = placeQuery.value(0).toInt();
        QString type = placeQuery.value(1).toString();
        ui->Place->addItem(QString("№%1 (%2)").arg(id).arg(type));
    }
}

int addsession::getClientId() const
{
    return ui->Client->currentData().toInt();
}

int addsession::getPlaceId() const
{
    return ui->Place->currentData().toInt();
}

QTime addsession::getSessionStart() const
{
    return ui->SessionStart->time();
}

QTime addsession::getSessionEnd() const
{
    return ui->SessionEnd->time();
}
