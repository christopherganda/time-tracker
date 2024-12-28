# System Design
This document contains the details of ideas and implementation for time tracker system.

## Functional Requirements
1. **Follow & Unfollow**
      - As a user, I can follow & unfollow other users.
2. **Clock in**
      - As a user, I can clock in.
      - As a user, I can retreive all clock-ins time ordered by created time.
3. **View sleep records of following users**
      - As a user, I can view all sleep records of my following's users on previous week ordered by sleep length(longest to shortest).

## Non Requirement
- User registration
- User Login
- User authentication

## Non-Functional Requirements
1. **Scalability**
      - The system needs to handle high volume of data and high traffic.
      - The system have to support concurrent requests
2. **CAP Theorem**
      - We aim for consistency and availability considering we can give consistent information and no downtime especially in peak time.
      - We achieved consistency by using PostgreSQL's ACID.
      - We achieved availability by using replication.
3. **Performance**
      - p95 100ms

## Quantitative Analysis

## Schemas
