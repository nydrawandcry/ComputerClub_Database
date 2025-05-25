#include "addclient.h"
#include "ui_addclient.h"

addclient::addclient(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::addclient)
{
    ui->setupUi(this);
}

addclient::~addclient()
{
    delete ui;
}

QString addclient::getName() const
{
    return ui->ClientName->text();
}

int addclient::getAge() const
{
    return ui->ClientAge->value();
}

QString addclient::getPhone() const
{
    return ui->ClientPhone->text();
}

double addclient::getBalance() const
{
    return ui->ClientBalance->value();
}

QString addclient::getStatus() const
{
    return ui->ClientStatus->text();
}
