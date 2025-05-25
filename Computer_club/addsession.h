#ifndef ADDSESSION_H
#define ADDSESSION_H

#include <QDialog>

namespace Ui {
class addconnection;
}

class addconnection : public QDialog
{
    Q_OBJECT

public:
    explicit addconnection(QWidget *parent = nullptr);
    ~addconnection();

private:
    Ui::addconnection *ui;
};

#endif // ADDSESSION_H
