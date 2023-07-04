import sqlite3




class DBClients:
    def __init__(self):
        self.conn = sqlite3.connect('clients.db')
        self.cursor = self.conn.cursor()
        self.create_clients_table()


    def create_clients_table(self):
        self.cursor.execute('''CREATE TABLE IF NOT EXISTS clients
                               (username TEXT PRIMARY KEY, password TEXT)''')
        self.conn.commit()



    def register_client(self, username, password):
        try:
            self.cursor.execute('INSERT INTO clients VALUES (?, ?)', (username, password))
            self.conn.commit()
            return True
        except sqlite3.Error:
            return False

    def authenticate_client(self, username, password):
        self.cursor.execute('SELECT * FROM clients WHERE username = ? AND password = ?', (username, password))
        result = self.cursor.fetchone()
        return result is not None


    def check_username_exists(self, username):
        self.cursor.execute('SELECT * FROM clients WHERE username = ?', (username,))
        result = self.cursor.fetchone()
        return result is not None

    def get_all_usernames(self):
        self.cursor.execute('SELECT username FROM clients')
        result = self.cursor.fetchall()
        usernames = [row[0] for row in result]
        return usernames

dbClients =DBClients()