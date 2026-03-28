***

# **CyberBank Web Application Security Assessment Report**

---

## **1. Introduction**

This document presents the findings of a targeted security assessment conducted on the CyberBank web application (accessed via `http://web0x06.hbtn`). The primary objective of this engagement was to evaluate the application's authorization controls, data privacy mechanisms, and overall resilience against common web application vulnerabilities.

The assessment focused heavily on identifying **Insecure Direct Object Reference (IDOR)** vulnerabilities and Information Disclosure flaws within the application's user dashboard, transaction history, and contact management features. 

The testing was performed in a simulated environment, demonstrating how malicious actors could exploit these flaws to uncover sensitive user data and bypass intended access controls.

---

## **2. Methodology**

The assessment was conducted using a manual penetration testing approach, emphasizing traffic interception, API analysis, and parameter manipulation. 

The primary tool utilized during this assessment was **Burp Suite Professional/Community Edition**, alongside native browser Developer Tools (Network Tab). The following techniques and functionalities were employed:

* **Traffic Interception:** Capturing HTTP/HTTPS requests and responses between the client and the CyberBank server using Burp Proxy.
* **API Enumeration:** Analyzing JSON responses in the browser's Network tab to understand data structures, endpoint behavior, and parameter naming conventions.
* **Parameter Tampering:** Utilizing Burp Suite's Repeater tool to modify request payloads (specifically User IDs) and resend them to the server to test for authorization flaws.
* **Cryptographic Analysis:** Identifying patterns in user identifiers, specifically recognizing and reproducing MD5 hash functions used for ID generation.

The methodology prioritized understanding the application's internal logic before attempting controlled exploitation to extract unauthorized data (Flags).

---

## **3. Vulnerability Details**

---

### **3.1 Insecure Direct Object Reference (IDOR) on User Profile Endpoint**

#### **Description**

The CyberBank application suffers from a critical Insecure Direct Object Reference (IDOR) vulnerability on its user information API endpoint. The server relies entirely on client-provided input (the user ID) to fetch account details without verifying if the authenticated session making the request is authorized to view that specific ID's data. 

#### **Technical Analysis**

During the assessment, it was observed that the application fetches user data via a `POST` request to the `info` endpoint. The request body contains a JSON payload specifying the `customer_id`. 

For the authenticated user ("yosri"), the ID was `08229ccec685426fb2ed082a067015ee`. By replacing this ID with the ID of another user (e.g., "Megan White"), the server responded with a `200 OK` status and returned the victim's complete financial profile, including account numbers, routing numbers, balances, and linked card IDs. The backend fails to map the requested `customer_id` against the currently established session cookie.

#### **Impact**

* **High:** Complete breach of data confidentiality.
* An attacker can systematically enumerate and extract the financial details, account numbers, and balances of any user within the CyberBank system.
* This data could be leveraged for further targeted attacks, such as wire fraud or identity theft.

#### **Reproduction Steps**

1.  Authenticate to the CyberBank application as a standard user.
2.  Navigate to the Dashboard to trigger the `info` API call.
3.  Intercept the `POST` request to the `info` endpoint using Burp Suite.
    ```json
    // Original Request Body
    {"customer_id": "08229ccec685426fb2ed082a067015ee"}
    ```
4.  Modify the `customer_id` parameter to a known victim's ID (e.g., Megan White's ID: `c37eb062d0634360ae61c3cbf198a555`).
5.  Forward the modified request to the server.
6.  Observe the server response containing the victim's sensitive account information.

#### **Evidence**

* Intercepted request showing the modified `customer_id` payload.
* Server response (JSON) containing unauthorized data belonging to `Megan White`, including sensitive `account_id` and `balance` fields.

---

### **3.2 Information Disclosure & Weak Identifier Generation**

#### **Description**

The application utilizes highly predictable methods for generating User IDs and unnecessarily exposes the internal IDs of other users through the contacts API endpoint.

#### **Technical Analysis**

Two distinct but related issues compound the IDOR vulnerability described above:

1.  **Predictable IDs (MD5 Hashing):** Analysis of the authenticated user's ID (`08229ccec685426fb2ed082a067015ee` for username "yosri") revealed that the system generates User IDs by simply calculating the MD5 hash of the user's username. This is a severe cryptographic flaw, as MD5 is deterministic and easily reproducible. If an attacker knows a target's username, they can instantly compute their User ID.
2.  **Information Disclosure:** Even without calculating the MD5 hash, the application's `contacts` endpoint returns a JSON array containing the full names and the exact `customer_id` (the MD5 hash) of all users available for quick transfers (e.g., returning `"contact_id":"c37eb062d0634360ae61c3cbf198a555"` for Megan White). 

#### **Impact**

* **Medium-High:** While not a direct exploit itself, this vulnerability acts as a massive enabler for the IDOR flaw. It removes the need for an attacker to guess or brute-force user IDs, providing them with a direct "directory" of targets to exploit.

#### **Reproduction Steps**

1.  Authenticate to the application.
2.  Open the browser's Developer Tools (Network Tab).
3.  Observe the response from the `contacts` API endpoint.
4.  Note the cleartext exposure of `contact_id` hashes mapped to specific user names.
5.  Alternatively, take any known username (e.g., "yosri") and generate an MD5 hash to confirm it matches the assigned User ID.

#### **Evidence**

* JSON response snippet from the `contacts` endpoint showing the mapping of `firstname` and `lastname` to internal `contact_id` hashes.

---

## **4. Additional Findings**

No further vulnerabilities were thoroughly explored outside the scope of the assigned IDOR and Information Disclosure tasks. However, the presence of these fundamental authorization flaws suggests a high probability that similar logical errors exist in other transactional endpoints (e.g., the wire transfer mechanism).

---

## **5. Recommendations**

---

### **Remediation for IDOR (Access Control)**

* **Implement Robust Server-Side Authorization:** The application must never rely on client-provided IDs to determine access rights. When the `info` endpoint is called, the server should extract the user's identity from the secure session token (e.g., JWT or session cookie) stored on the server side, not from the request body.
* **Validate Ownership:** If an endpoint legitimately requires passing an ID (e.g., viewing a specific transaction), the backend must perform an explicit check: `if (requested_record.owner_id == current_session.user_id) { return data; } else { return 403 Forbidden; }`.

### **Remediation for Identifier Generation & Disclosure**

* **Use Cryptographically Secure Random Identifiers:** Cease the use of MD5 hashes of usernames as User IDs. Implement Universally Unique Identifiers (UUIDv4) or another form of cryptographically secure pseudo-random number generation (CSPRNG) for all database primary keys and user references.
* **Data Minimization:** Review the `contacts` API endpoint. The application should only return the minimum amount of data necessary for the UI to function. Internal database IDs or hashes should not be exposed to the client unless absolutely necessary.

---

## **6. Conclusion**

The security assessment of the CyberBank application revealed critical flaws in its access control architecture. The combination of predictable User IDs, API Information Disclosure, and a severe IDOR vulnerability allows any authenticated user to systematically harvest sensitive financial data of all other users on the platform. 

Addressing these vulnerabilities requires a fundamental shift in how the application handles authorization, moving away from trusting client input and toward enforcing strict, session-based server-side checks. Immediate remediation is strongly advised to protect user privacy and prevent potential financial fraud.

---

## **7. References**

* OWASP Top 10:2021 - A01:2021-Broken Access Control
* OWASP Web Security Testing Guide: Testing for Insecure Direct Object References (WSTG-ATHZ-04)
* PortSwigger Web Security Academy: Insecure Direct Object References (IDOR)
