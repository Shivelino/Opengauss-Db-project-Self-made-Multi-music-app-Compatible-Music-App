package DbWorkers;

import java.sql.*;
import java.util.Properties;

abstract class DbWorkerBase
{
    protected Connection conn;  // jdbc connection
    protected String db_url;  // jdbc db_url of connection
    protected Properties info;  // jdbc info of connection:username, password
    protected Statement stmt;  // jdbc statement. To execute sql.

    protected DbWorkerBase()
    {
        loadDriver();
    }

    protected DbWorkerBase(String url, Properties info)
    {
        this();
        this.db_url = url;
        this.info = info;
        connect();
    }

    protected DbWorkerBase(String db_type, String ip, String port, String db_name, Properties info)
    {
        this();
        this.db_url = "jdbc:" + db_type + "://" + ip + ":" + port + "/" + db_name;
        this.info = info;
        connect();
    }

    protected DbWorkerBase(String db_type, String ip, String port, String db_name, String user, String password)
    {
        this();
        this.db_url = "jdbc:" + db_type + "://" + ip + ":" + port + "/" + db_name;
        this.info = new Properties();
        this.info.setProperty("user", user);
        this.info.setProperty("password", password);
        connect();
    }

    protected abstract void loadDriver();  // load database driver

    protected void connect()  // connect db
    {
        try
        {
            this.conn = DriverManager.getConnection(this.db_url, this.info);
            this.stmt = conn.createStatement();
        }
        catch (SQLException e)
        {
            System.out.println("Connection Failed.");
            e.printStackTrace();
        }
    }

    public ResultSet executeQuery(String sql)
    {
        ResultSet result = null;
        try
        {
            result = this.stmt.executeQuery(sql);
        }
        catch (SQLException e)
        {
            System.out.println("Sql Query Failed.");
            e.printStackTrace();
        }
        return result;
    }

    public int executeUpdate(String sql)
    {
        {
            int result = -1;
            try
            {
                result = this.stmt.executeUpdate(sql);
            }
            catch (SQLException e)
            {
                System.out.println("Sql Update Failed.");
                e.printStackTrace();
            }
            return result;
        }
    }

    public boolean executeOther(String sql)
    {
        {
            boolean result = false;
            try
            {
                result = this.stmt.execute(sql);
            }
            catch (SQLException e)
            {
                System.out.println("Sql Execute Other(not Query or Update) Failed.");
                e.printStackTrace();
            }
            return result;
        }
    }

    @Override
    protected void finalize() throws Throwable
    {
        this.stmt.close();
        this.conn.close();
    }
}

public class DbWorkerOpenGauss extends DbWorkerBase
{
    public DbWorkerOpenGauss(String url, Properties info)
    {
        super(url, info);
    }

    public DbWorkerOpenGauss(String ip, String port, String db_name, String user, String password)
    {
        super("postgresql", ip, port, db_name, user, password);
    }

    public DbWorkerOpenGauss(String ip, String port, String db_name, Properties info)
    {
        super("postgresql", ip, port, db_name, info);
    }

    @Override
    protected void loadDriver()
    {
        try
        {
            // openGauss is much more like postgresql, and the code refers from official documents.
            // TODO Guess maybe postgresql and openGauss can share the same code. Could give it a try.
            Class.forName("org.postgresql.Driver");
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
