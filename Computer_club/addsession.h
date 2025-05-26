#ifndef ADDSESSION_H
#define ADDSESSION_H

#include <QDialog>
#include <QSqlQuery>

namespace Ui {
class addsession;
}

class addsession : public QDialog
{
    Q_OBJECT

public:
    explicit addsession(QWidget *parent = nullptr);
    ~addsession();

    void load_data();

    int getClientId()const;
    int getPlaceId()const;

    QTime getSessionStart()const;
    QTime getSessionEnd()const;

private:
    Ui::addsession *ui;
};

#endif // ADDSESSION_H
