#include "editclient.h"
#include "ui_editclient.h"

editclient::editclient(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::editclient)
{
    ui->setupUi(this);
}

editclient::~editclient()
{
    delete ui;
}

void editclient::setClientData(const QString &name, int age, const QString &phone, double balance, const QString &status)
{
    ui->ClientName->setText(name);
    ui->ClientAge->setValue(age);
    ui->ClientPhone->setText(phone);
    ui->ClientBalance->setValue(balance);
    ui->ClientStatus->setText(status);
}

QString editclient::getName() const
{
    return ui->ClientName->text();
}

int editclient::getAge() const
{
    return ui->ClientAge->value();
}

QString editclient::getPhone() const
{
    return ui->ClientPhone->text();
}

double editclient::getBalance() const
{
    return ui->ClientBalance->value();
}

QString editclient::getStatus() const
{
    return ui->ClientStatus->text();
}
