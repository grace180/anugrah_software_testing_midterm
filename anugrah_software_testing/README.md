# anugrah_software_testing


## Test Cases

### Authentication Test Suite

#### TC_AUTH_VM_001: Validate Empty Username
**Description**: Ensure system returns error when username is empty  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Call `validateUsername()` with empty string  
**Expected Result**: Returns "Username cannot be empty"

#### TC_AUTH_VM_002: Validate Short Password  
**Description**: Ensure system returns error for short passwords  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Call `validatePassword()` with 5-character string  
**Expected Result**: Returns "Password must be at least 6 characters"

#### TC_AUTH_VM_003: Successful Login  
**Description**: Verify login with valid credentials  
**Preconditions**: 
- AuthViewModel initialized
- Mock service configured for success response  
**Test Steps**:
1. Call `login()` with valid credentials ("testuser", "password123")  
**Expected Result**: 
- `currentUser` populated
- No error message

#### TC_AUTH_VM_004: Login with Invalid Credentials  
**Description**: Ensure system denies invalid credentials  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Call `login()` with ("invaliduser", "wrongpassword")  
**Expected Result**: Returns "Invalid credentials" error

#### TC_AUTH_VM_005: Logout Functionality  
**Description**: Verify session termination on logout  
**Preconditions**: 
- AuthViewModel initialized
- User logged in  
**Test Steps**:
1. Call `logout()`
2. Attempt to access protected resource  
**Expected Result**: 
- `currentUser` becomes null
- Protected access fails

#### TC_AUTH_VM_006: Username Length Boundary Values  
**Description**: Test username length limits  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Test with 1-character username
2. Test with 20-character username 
3. Test with 21-character username  
**Expected Results**:
1-2. Returns null (valid)
3. Returns "Username cannot exceed 20 characters"

#### TC_AUTH_VM_007: Password Length Boundary Values  
**Description**: Test password length limits  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Test with 6-character password
2. Test with 50-character password
3. Test with 5-character password
4. Test with 51-character password  
**Expected Results**:
1-2. Returns null (valid)
3. Returns "Password must be at least 6 characters"
4. Returns "Password cannot exceed 50 characters"

#### TC_AUTH_VM_008: Login with Special Characters in Username  
**Description**: Ensure system rejects special chars in username  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Test with username containing @
2. Test with username containing space
3. Test with username containing hyphen  
**Expected Result**: Returns "Username can only contain alphanumeric characters"

#### TC_AUTH_VM_009: Login with SQL Injection Attempt  
**Description**: Verify system security against SQL injection  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Attempt login with SQL injection in username
2. Attempt login with SQL injection in password  
**Expected Result**: 
- Returns "Invalid credentials"
- System remains secure

#### TC_AUTH_VM_010: Login with Empty Fields  
**Description**: Test handling of empty credentials  
**Preconditions**: AuthViewModel initialized  
**Test Steps**:
1. Attempt login with empty username
2. Attempt login with empty password
3. Attempt login with both fields empty  
**Expected Result**: Returns appropriate field validation errors
