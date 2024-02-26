import java.io.*;
import java.sql.*;
import java.net.URL;
import java.util.*;

/*
 * CPS610 Group 5
 * Lab 4
 * Eric 
 * Jacob 
 * Kourosh 
 * Paul Sztwiertnia 
 * To use: Please have a file named "input.txt" with username on line 1, password on line 2.
 * Ensure you've run "A4_Tables.sql" before using this java file (Ensure the tables exist).
 */

public class Lab4 {

	public static void main(String[] args) throws SQLException, IOException {
		//Driver stuff
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		}catch(ClassNotFoundException x) {
			System.out.println("Driver could not be loaded");
		}
		//Connection stuff
		String dbacct, pass, name;
		dbacct = null;
		pass = null;
		Scanner scanner = new Scanner(System.in);
		try {
			//Get info from input file
			URL url = Lab1.class.getResource("input.txt");
			Scanner in = new Scanner(new FileInputStream(url.toString().substring(6)));
			dbacct = in.nextLine();
			pass = in.nextLine();
			in.close();
		}
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		if (dbacct == null) {//Couldn't read input file, abort
			System.exit(0);
		}
		
		//Make connection
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:"+dbacct+"/"+pass+"@localhost:1521:Engineering");
		//Connection conn = DriverManager.getConnection("jdbc:oracle:thin:"+dbacct+"/"+pass+"@oracle.scs.ryerson.ca:1521:orcl");
		conn.setAutoCommit(true);
		
		//I.e. "W(1,2);C W(2,5);C "
		System.out.println("Please enter your transactions (C denotes the end of each transaction. Please leave a space after each 'C'.):");
		String tasks = scanner.nextLine();
		
		String[] transactions = tasks.split(" ");
		ArrayList<ArrayList<ArrayList<String>>> actions = new ArrayList<ArrayList<ArrayList<String>>>();//Main storage for transactions
		
		//Temp storage used for converting input into An array of arrays of arrays. (Array (transactions), Array(actions), Array(action details)
		ArrayList<String> temp;
		ArrayList<ArrayList<String>> tempTransaction = new ArrayList<ArrayList<String>>();
		
		//Converts input format for main storage
		for(String act: transactions) {
			tempTransaction = new ArrayList<ArrayList<String>>();
			temp = new ArrayList<>(Arrays.asList(act.split(";")));
			for(String a: temp) {
				//Regex to remove useless text
				tempTransaction.add(new ArrayList<>(Arrays.asList(a.split("[(),]"))));
			}
			actions.add(tempTransaction);
		}
		
		//DEBUG
		//System.out.println(actions);
		//System.exit(0);
		
		Boolean[] complete = new Boolean[actions.size()]; //USE TO TRACK COMPLETE TRANSACTIONS
		int totalDone = 0;
		
		for(int x = 0; x<complete.length; x++) {
			complete[x] = false;
		}
		int timestamp = 0;// timestamp counter
		Integer prevTimeRead = null; // Previous timestamp
		Integer prevTimeWrite = null; // Previous timestamp
		Integer prevTimeCommit = null;// Previous timestamp
		String stmt1 = "select RID, LockStatus, TID, NumReads from Lock_Table where RID= ?";
		String insert = "insert into A4_Table(ID, DataValue) values(?, ?)";
		String update = "UPDATE A4_Table SET DataValue=? Where ID=?";
		String updateL = "UPDATE Lock_Table SET LockStatus=? Where TID=?";
		String read = "select * from A4_Table Where ID=?";
		String readR = "select COUNT(*) as total from A4_Table WHERE ID=?";
		String commit = "delete from Lock_Table where TID=?";
		String insertLock = "insert into Lock_Table(RID, LockStatus, TID, NumReads) Values(?, ?, ?, ?)";
		String insertLog = "insert into TRANSACTION_LOG(LOGTIME, TID, RID, OLDVALUE, NEWVALUE, PREVTIME) Values(?, ?, ?, ?, ?, ?)";
		
		PreparedStatement p = conn.prepareStatement(stmt1);
		PreparedStatement insertP = conn.prepareStatement(insert);
		PreparedStatement updateP = conn.prepareStatement(update);
		PreparedStatement updateLP = conn.prepareStatement(updateL);
		PreparedStatement readP = conn.prepareStatement(read);
		PreparedStatement readExist = conn.prepareStatement(readR);
		PreparedStatement commitP = conn.prepareStatement(commit);
		PreparedStatement insertLockP = conn.prepareStatement(insertLock);
		PreparedStatement insertLogP = conn.prepareStatement(insertLog); // prepared statement for inserting log entries

		

		
		
		ResultSet r = null;
		
		int rid=0, lockstatus=0, tid=0, numreads=0;
		Boolean skip = false; //Use for round robin/waiting
		//Consider having a storage of current locks found in an array
		//LOCKSTATUS: 0 = NONE, 1 = READ/SHARED, 2 = WRITE/EXCLUSIVE
		int i = 0;
		while(totalDone < actions.size()) {
			if (complete[i]) { //If transaction is complete, go to next
				i++;
				i = i % actions.size();
				continue;
			}
			skip = false;
			tempTransaction = actions.get(i);
			for(int j = 0; j < tempTransaction.size(); j++) {//Goes through the actions in a given transaction
				if(skip && ((actions.size()-totalDone) > 1)) {//If current transaction needs to wait, or has completed an action, go to next transaction (If there's more than one)
					break;
				}
				
				//Clear variables
				rid = -1;
				lockstatus = -1;
				tid = -1;
				numreads = -1;
				p.clearParameters();
				
				//DEBUG
				//System.out.println(tempTransaction.get(j).get(0));
				//System.out.println(actions);
				
				switch(tempTransaction.get(j).get(0)) {
				case "C"://Commits
					commitP.setInt(1, i);
					commitP.executeUpdate();//Delete transaction locks
					totalDone++;
					complete[i] = true;
					insertLogP.setInt(1, ++timestamp);
				    insertLogP.setInt(2, i);
				    insertLogP.setInt(3, 0);
				    insertLogP.setString(4, "Comitted");
				    insertLogP.setString(5, "Comitted");
				    if(prevTimeCommit != null){
				    	insertLogP.setInt(6, prevTimeCommit);
				    }else
				    {
				    	insertLogP.setInt(6, timestamp);
				    }
				    
				    prevTimeCommit = timestamp;
				    insertLogP.executeUpdate();
					System.out.println("Did a commit (Transaction " + i + ")" + ". Enter to continue");
					scanner.nextLine();
					actions.get(i).get(j).set(0, "D");//Set current action as done
					break;
				case "W"://Writes
					p.setInt(1,  Integer.parseInt(tempTransaction.get(j).get(1)));
					readExist.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
					r = p.executeQuery();//Check lock status
					while(r.next()) { //Probably don't need a loop (Can just run next, then get info)
						rid = r.getInt(1);
						lockstatus = r.getInt(2);
						tid = r.getInt(3);
						numreads = r.getInt(4);
					}
					
					r = readExist.executeQuery();//Checks if record exists in A4 Table
					r.next();
					
					if(rid != -1) {//If there's a lock/lock record
						if (tid != i) {//Doesn't belong to current transaction
							//Wait
							System.out.println("Transaction " + (i) + "'s write is waiting");
							skip = true;
						}
						else {//Belongs to current transaction
							//Update lockstatus to 2
							updateLP.clearParameters();
							updateLP.setInt(1, 2);
							updateLP.setInt(2, i);
							updateLP.executeUpdate();
							
							if(r.getInt("total") < 1) {
								//Insert if row is new
								System.out.println("Inserted w/lock");
								insertP.clearParameters();
								insertP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
								insertP.setInt(2, Integer.parseInt(tempTransaction.get(j).get(2)));
								insertP.executeUpdate();
								readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
								insertLogP.setInt(1, ++timestamp);
							    insertLogP.setInt(2, i);
							    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
							    insertLogP.setString(4, String.valueOf(Integer.parseInt(tempTransaction.get(j).get(2))));
							    insertLogP.setString(5, String.valueOf(Integer.parseInt(tempTransaction.get(j).get(2))));
							    if(prevTimeWrite != null){
							    	insertLogP.setInt(6, prevTimeWrite);
							    }else
							    {
							    	insertLogP.setInt(6, timestamp);
							    }
							    
							    prevTimeWrite = timestamp;
							    insertLogP.executeUpdate();
							}
							else {//Update record otherwise
								readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
								r = readP.executeQuery();
								if(r.next()) {
									insertLogP.clearParameters();
									insertLogP.setInt(1, ++timestamp);
								    insertLogP.setInt(2, i);
								    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
								    insertLogP.setString(4, String.valueOf(r.getInt(2)));
								}
								updateP.clearParameters();
								updateP.setInt(2, Integer.parseInt(tempTransaction.get(j).get(1)));
								updateP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(2)));
								System.out.println("Updated w/ lock");
								updateP.executeUpdate();
								insertLogP.setString(5, String.valueOf(tempTransaction.get(j).get(2)));
								if(prevTimeWrite != null){
							    	insertLogP.setInt(6, prevTimeWrite);
							    }else
							    {
							    	insertLogP.setInt(6, timestamp);
							    }
							    
							    prevTimeWrite = timestamp;
							    insertLogP.executeUpdate();
							}
							System.out.print("Transaction " + i + " ");
							System.out.println("Did a write. Enter to continue");
							scanner.nextLine();
							skip = true;
							actions.get(i).get(j).set(0, "D");//Set current action as done
						}
					}
					else {//No lock/lock record exists
						//Add exclusive lock to table
						insertLockP.clearParameters();
						insertLockP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
						insertLockP.setInt(2, 2);
						insertLockP.setInt(3, i);
						insertLockP.setInt(4, 0);
						insertLockP.executeUpdate();
						
						if(r.getInt("total") < 1) {
							//Insert if row is new
							System.out.println("Inserted no lock");
							insertP.clearParameters();
							insertP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
							insertP.setInt(2, Integer.parseInt(tempTransaction.get(j).get(2)));
							insertP.executeUpdate();
							insertLogP.clearParameters();
							insertLogP.setInt(1, ++timestamp);
						    insertLogP.setInt(2, i);
						    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
						    insertLogP.setString(4, String.valueOf(Integer.parseInt(tempTransaction.get(j).get(2))));
						    insertLogP.setString(5, String.valueOf(Integer.parseInt(tempTransaction.get(j).get(2))));
						    if(prevTimeWrite != null){
						    	insertLogP.setInt(6, prevTimeWrite);
						    }else
						    {
						    	insertLogP.setInt(6, timestamp);
						    }
						    
						    prevTimeWrite = timestamp;
						    insertLogP.executeUpdate();
						}
						else {//Update record otherwise
							readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
							r = readP.executeQuery();
							if(r.next()) {
								insertLogP.clearParameters();
								insertLogP.setInt(1, ++timestamp);
							    insertLogP.setInt(2, i);
							    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
							    insertLogP.setString(4, String.valueOf(r.getInt(2)));
							}
							updateP.clearParameters();
							updateP.setInt(2, Integer.parseInt(tempTransaction.get(j).get(1)));
							updateP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(2)));
							System.out.println("Updated no lock");
							updateP.executeUpdate();
						    insertLogP.setString(5, String.valueOf(tempTransaction.get(j).get(2)));
						    if(prevTimeWrite != null){
						    	insertLogP.setInt(6, prevTimeWrite);
						    }else
						    {
						    	insertLogP.setInt(6, timestamp);
						    }
						    
						    prevTimeWrite = timestamp;
						    insertLogP.executeUpdate();
						}
						System.out.print("Transaction " + i + " ");
						System.out.println("Did a write. Enter to continue");
						scanner.nextLine();
						skip = true;
						actions.get(i).get(j).set(0, "D");
					}
					break;
				case "R"://Reads
					p.setInt(1,  Integer.parseInt(tempTransaction.get(j).get(1)));
					//p.setString(1, acts.get(1));
					r = p.executeQuery();
					while(r.next()) {
						rid = r.getInt(1);
						lockstatus = r.getInt(2);
						tid = r.getInt(3);
						numreads = r.getInt(4);
					}
					if (rid != -1) {
						if (tid != i) {
							if (lockstatus == 2) {
								//wait
								System.out.println("Transaction " + (i) + "'s read is waiting");
								skip = true;
							}
							else {
								//have shared lock, read record
								readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
								r = readP.executeQuery();
								if(r.next()) {
									System.out.println(r.getInt(2));
									insertLogP.clearParameters();
									insertLogP.setInt(1, ++timestamp);
								    insertLogP.setInt(2, i);
								    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
								    insertLogP.setString(4, String.valueOf(r.getInt(2)));
								    insertLogP.setString(5, String.valueOf(r.getInt(2)));
								    if(prevTimeRead != null){
								    	insertLogP.setInt(6, prevTimeRead);
								    }else
								    {
								    	insertLogP.setInt(6, timestamp);
								    }
								    
								    prevTimeRead = timestamp;
								    insertLogP.executeUpdate();
								}
								else {
									insertLogP.clearParameters();
									insertLogP.setInt(1, ++timestamp);
								    insertLogP.setInt(2, i);
								    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
								    insertLogP.setString(4, "No data found.");
								    insertLogP.setString(5, "No data found.");
								    if(prevTimeRead != null){
								    	insertLogP.setInt(6, prevTimeRead);
								    }else
								    {
								    	insertLogP.setInt(6, timestamp);
								    }
								    
								    prevTimeRead = timestamp;
								    insertLogP.executeUpdate();
									System.out.println("No data found.");
								}
							    //insertLogP.executeUpdate();
								skip = true;
								actions.get(i).get(j).set(0, "D");
								System.out.print("Transaction " + i + " ");
								System.out.println("Did a read. Enter to continue");
								scanner.nextLine();
							}
						}
						else {
							//Read
							readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
							r = readP.executeQuery();
							if(r.next()) {
								insertLogP.clearParameters();
								insertLogP.setInt(1, ++timestamp);
							    insertLogP.setInt(2, i);
							    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
							    insertLogP.setString(4, String.valueOf(r.getInt(2)));
							    insertLogP.setString(5, String.valueOf(r.getInt(2)));
							    if(prevTimeRead != null){
							    	insertLogP.setInt(6, prevTimeRead);
							    }else
							    {
							    	insertLogP.setInt(6, timestamp);
							    }
							    
							    prevTimeRead = timestamp;
							    insertLogP.executeUpdate();
								System.out.println(r.getInt(2));
							}
							else {
								insertLogP.clearParameters();
								insertLogP.setInt(1, ++timestamp);
							    insertLogP.setInt(2, i);
							    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
							    insertLogP.setString(4, "No data found.");
							    insertLogP.setString(5, "No data found.");
							    if(prevTimeRead != null){
							    	insertLogP.setInt(6, prevTimeRead);
							    }else
							    {
							    	insertLogP.setInt(6, timestamp);
							    }
							    
							    prevTimeRead = timestamp;
							    insertLogP.executeUpdate();
								System.out.println("No data found.");
							}
							
							//Add shared lock
							insertLockP.clearParameters();
							insertLockP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
							insertLockP.setInt(2, 1);
							insertLockP.setInt(3, i);
							insertLockP.setInt(4, 1);
							insertLockP.executeUpdate();
							
							skip = true;
							actions.get(i).get(j).set(0, "D");
							System.out.print("Transaction " + i + " ");
							System.out.println("Did a read. Enter to continue");
							scanner.nextLine();
						}
					}
					else {
						//Read
						readP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
						r = readP.executeQuery();
						if(r.next()) {
							insertLogP.clearParameters();
							insertLogP.setInt(1, ++timestamp);
						    insertLogP.setInt(2, i);
						    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
						    insertLogP.setString(4, String.valueOf(r.getInt(2)));
						    insertLogP.setString(5, String.valueOf(r.getInt(2)));
						    if(prevTimeRead != null){
						    	insertLogP.setInt(6, prevTimeRead);
						    }else
						    {
						    	insertLogP.setInt(6, timestamp);
						    }
						    
						    prevTimeRead = timestamp;
						    insertLogP.executeUpdate();
							System.out.println(r.getInt(2));
						}
						else {
							insertLogP.clearParameters();
							insertLogP.setInt(1, ++timestamp);
						    insertLogP.setInt(2, i);
						    insertLogP.setInt(3, Integer.parseInt(tempTransaction.get(j).get(1)));
						    insertLogP.setString(4, "No data found.");
						    insertLogP.setString(5, "No data found.");
						    if(prevTimeRead != null){
						    	insertLogP.setInt(6, prevTimeRead);
						    }else
						    {
						    	insertLogP.setInt(6, timestamp);
						    }
						    
						    prevTimeRead = timestamp;
						    insertLogP.executeUpdate();
							System.out.println("No data found.");
						}
						
						//Add shared lock
						insertLockP.clearParameters();
						insertLockP.setInt(1, Integer.parseInt(tempTransaction.get(j).get(1)));
						insertLockP.setInt(2, 1);
						insertLockP.setInt(3, i);
						insertLockP.setInt(4, 1);
						insertLockP.executeUpdate();
						
						skip = true;
						actions.get(i).get(j).set(0, "D");
						System.out.print("Transaction " + i + " ");
						System.out.println("Did a read. Enter to continue");
						scanner.nextLine();
					}
					break;
				}
			}
			i++;
			i = i % actions.size();
		}
		
		System.out.println("Done.");
		//System.out.println(actions);
		r.close();
		scanner.close();
		conn.close();
	}
	
}



