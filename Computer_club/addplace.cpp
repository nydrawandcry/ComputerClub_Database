#include "addplace.h"
#include "ui_addplace.h"

addplace::addplace(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::addplace)
{
    ui->setupUi(this);
}

addplace::~addplace()
{
    delete ui;
}

QString addplace::getType() const
{
    return ui->PlaceType->text();
}
