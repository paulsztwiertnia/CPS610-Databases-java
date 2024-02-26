import java.io.*;
import java.sql.*;
import java.net.URL;
import java.util.*;

/*
 * CPS610 Group 5
 * Lab 1
 * Eric 
 * Jacob 
 * Kourosh 
 * Paul Sztwiertnia 
 * To use: Please have a file named "input.txt" with username on line 1, password on line 2.
 * Ensure you've run "Tables.sql" before using this java file (Ensure the tables exist).
 */

public class Lab1 {

	public static void main(String[] args) throws SQLException, IOException {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		}catch(ClassNotFoundException x) {
			System.out.println("Driver could not be loaded");
		}
		String dbacct, pass, name;
		dbacct = null;
		pass = null;
		char grade;
		int credit;
		Scanner scanner = new Scanner(System.in);
		//try {
		//	URL url = Lab1.class.getResource("input.txt");
		//	Scanner in = new Scanner(new FileInputStream(url.toString().substring(6)));
		//	dbacct = in.nextLine();
		//	pass = in.nextLine();
		//	in.close();
		//}
		//catch (FileNotFoundException e) {
		//	e.printStackTrace();
		//}
		System.out.println("Enter your username:");
		dbacct = scanner.nextLine();
		System.out.println("Enter your pass:");
		
		pass = scanner.nextLine();
		if (dbacct == null) {
			System.exit(0);
		}
		//Connection conn = DriverManager.getConnection("jdbc:oracle:oci8:"+dbacct+"/"+pass);
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:"+dbacct+"/"+pass+"@oracle.scs.ryerson.ca:1521:orcl");
		String stmt1 = "select G.grade, C.credit_hours "
				+ "from STUDENT S, GRADE_REPORT G, SECTION SEC, COURSE C "
				+ "where G.Student_number = S.Student_number AND G.Section_identifier="
				+ "SEC.Section_identifier AND SEC.Course_number=C.Course_number AND S.Name=?";
		PreparedStatement p = conn.prepareStatement(stmt1);
		System.out.println("Enter your name:");
		name = scanner.nextLine();
		p.clearParameters();
		p.setString(1, name);
		ResultSet r = p.executeQuery();
		double count=0, sum=0, avg=0;
		while(r.next()) {
			grade = r.getString("Grade").charAt(0);
			credit = r.getInt(2);
			switch(grade) {
				case 'A': sum += (4*credit); count += 1; break;
				case 'B': sum += (3*credit); count += 1; break;
				case 'C': sum += (2*credit); count += 1; break;
				case 'D': sum += (1*credit); count += 1; break;
				case 'F': sum += (0*credit); count += 1; break;
				default: System.out.println("This grade "+grade+"will not be calculated"); break;
			}
		};
		avg = sum/count;
		System.out.println("Student named "+name+" has a grade point average of "+avg+".");
		r.close();
		scanner.close();
	}

}
