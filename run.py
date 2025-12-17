import sys
from PySide6.QtWidgets import QApplication, QDialog

# Ventana principal
from views.ProductsWindow import ProductsWindow
# Nueva ventana de login
from views.login_window import LoginDialog
        
if __name__ == '__main__':
    app = QApplication(sys.argv)

    login = LoginDialog()
    if login.exec() == QDialog.Accepted:
        window = ProductsWindow(
            usuario_login=login.username,
            user_role=login.role
        )
        window.show()
        sys.exit(app.exec())
    else:
        sys.exit(0)