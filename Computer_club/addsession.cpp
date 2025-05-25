#include "addsession.h"
#include "ui_addsession.h"

addconnection::addconnection(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::addconnection)
{
    ui->setupUi(this);
}

addconnection::~addconnection()
{
    delete ui;
}
