#ifndef EDITPLACE_H
#define EDITPLACE_H

#include <QDialog>

namespace Ui {
class editplace;
}

class editplace : public QDialog
{
    Q_OBJECT

public:
    explicit editplace(QWidget *parent = nullptr);
    ~editplace();

    QString getType() const;

private:
    Ui::editplace *ui;
};

#endif // EDITPLACE_H
