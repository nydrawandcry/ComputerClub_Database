#include "editplace.h"
#include "ui_editplace.h"

editplace::editplace(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::editplace)
{
    ui->setupUi(this);
}

editplace::~editplace()
{
    delete ui;
}

void editplace::setPlaceData(QString &type)
{
    ui->PlaceType->setText(type);
}

QString editplace::getType() const
{
    return ui->PlaceType->text();
}
