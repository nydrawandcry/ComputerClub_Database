#ifndef ADDCLIENT_H
#define ADDCLIENT_H

#include <QDialog>

namespace Ui {
class addclient;
}

class addclient : public QDialog
{
    Q_OBJECT

public:
    explicit addclient(QWidget *parent = nullptr);
    ~addclient();

    QString getName() const;

    int getAge() const;

    QString getPhone() const;

    double getBalance() const;

    QString getStatus() const;

private:
    Ui::addclient *ui;
};

#endif // ADDCLIENT_H
