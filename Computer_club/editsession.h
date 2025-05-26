#ifndef EDITSESSION_H
#define EDITSESSION_H

#include <QDialog>

namespace Ui {
class editsession;
}

class editsession : public QDialog
{
    Q_OBJECT

public:
    explicit editsession(QWidget *parent = nullptr);
    ~editsession();

    void setClientPLaceData(int clientId, int placeId, QTime sessionStart, QTime sessionEnd);

    int getClientId()const;
    int getPlaceId()const;

    QTime getSessionStart()const;
    QTime getSessionEnd()const;

private:
    Ui::editsession *ui;
};

#endif // EDITSESSION_H
