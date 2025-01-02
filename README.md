# Time Tracker
This application/service allows users to track when they go to bed and when they wake up. <br />
Minimum requirement of the features:<br />
1. Clock in operation and return all clocked-in times ordered by created time
2. Users can follow and unfollow other users.
3. See the sleep records of a user's All following users' sleep
records. from the previous week, which are sorted based on the duration
of All friends sleep length.
This is 3rd requirement response example <br />
```
{
record 1 from user A,
record 2 from user B,
record 3 from user A,
...
}
```
4. The system needs to handle high volume of data and concurrent requests as the user grows.

# Specs
- Ruby on Rails

# Database Selection
We chose RDBMS for this system due to the following reasons:  
1. **Relationships**  
   - Users following other users and users clocking in.
2. **Complex Queries**  
   - Retrieving users' sleep lengths for the previous week.
3. **Transactional Operations**  
   - Ensuring data consitency when clocking in. 

For RDBMS, the popular options are PostgreSQL and MySQL. We chose PostgreSQL over MySQL for this scenario for the following reasons:
1. **Concurrent Requests**  
   - The system will handle concurrent requests (such as clock-in or follow/unfollow operations happening simultaneously).
   - PostgreSQL’s MVCC (Multi-Version Concurrency Control):
     - Is built-in and doesn't block read and write.
     - While MySQL with InnoDB also supports MVCC, it may rely on locking mechanisms in some cases, leading to higher latency due to blocking.

2. **Heavy write operations**  
   - The system is expected to handle a high volume of data as the user grows, we assume that the clock-in and follow/unfollow traffics are also high.
   - PostgreSQL is optimized for heavy write workloads, whereas MySQL is typically optimized for heavy read workloads.

## How to use
### 1. Install RVM
Follow the installation guide at [RVM Install](https://rvm.io/rvm/install).

### 2. Install Ruby on Rails
Use RVM to install the required Ruby version and then install Rails:
```bash
rvm install ruby-3.0.0
rvm use ruby-3.0.0 --default
gem install rails
```

### 3. Run Migration Commands
Prepare the database:
```bash
rails db:create
rails db:migrate
```

### 4. Run the Server
Start the Rails server:
```bash
rails server
```

### 5. Setup test db
Prepare the database:
```bash
RAILS_ENV=test rails db:drop
RAILS_ENV=test rails db:create
```

Navigate to `http://localhost:3000` to access the application.

