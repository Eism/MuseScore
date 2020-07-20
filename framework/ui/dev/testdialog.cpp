#include "testdialog.h"
#include "ui_testdialog.h"

TestDialog::TestDialog(const TestDialog &dialog) :
    QDialog(dialog.parentWidget()),
    ui(dialog.ui)
{
}

TestDialog::TestDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::TestDialog)
{
    ui->setupUi(this);
}

TestDialog::~TestDialog()
{
    delete ui;
}
