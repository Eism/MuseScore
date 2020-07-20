#ifndef TESTDIALOG_H
#define TESTDIALOG_H

#include <QDialog>

namespace Ui {
class TestDialog;
}

class TestDialog : public QDialog
{
    Q_OBJECT

public:
    TestDialog(const TestDialog& dialog);
    explicit TestDialog(QWidget *parent = nullptr);
    ~TestDialog();

private:
    Ui::TestDialog *ui;
};

Q_DECLARE_METATYPE(TestDialog)

#endif // TESTDIALOG_H
