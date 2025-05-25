#include "editsession.h"
#include "ui_editsession.h"

editconnection::editconnection(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::editconnection)
{
    ui->setupUi(this);
}

editconnection::~editconnection()
{
    delete ui;
}
