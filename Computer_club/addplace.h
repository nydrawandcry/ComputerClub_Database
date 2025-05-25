#ifndef ADDPLACE_H
#define ADDPLACE_H

#include <QDialog>

namespace Ui {
class addplace;
}

class addplace : public QDialog
{
    Q_OBJECT

public:
    explicit addplace(QWidget *parent = nullptr);
    ~addplace();

    QString getType() const;

private:
    Ui::addplace *ui;
};

#endif // ADDPLACE_H
