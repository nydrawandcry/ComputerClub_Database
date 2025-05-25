#ifndef EDITSESSION_H
#define EDITSESSION_H

#include <QDialog>

namespace Ui {
class editconnection;
}

class editconnection : public QDialog
{
    Q_OBJECT

public:
    explicit editconnection(QWidget *parent = nullptr);
    ~editconnection();

private:
    Ui::editconnection *ui;
};

#endif // EDITSESSION_H
