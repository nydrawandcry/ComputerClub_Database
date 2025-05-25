#ifndef EDITCLIENT_H
#define EDITCLIENT_H

#include <QDialog>

namespace Ui {
class editclient;
}

class editclient : public QDialog
{
    Q_OBJECT

public:
    explicit editclient(QWidget *parent = nullptr);
    ~editclient();

    void setClientData(const QString &name, int age, const QString &phone, double balance, const QString &status);

    QString getName() const;

    int getAge() const;

    QString getPhone() const;

    double getBalance() const;

    QString getStatus() const;

private:
    Ui::editclient *ui;
};

#endif // EDITCLIENT_H
