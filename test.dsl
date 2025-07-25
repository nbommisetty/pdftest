workspace "MRA Integration" "Logical diagram for integrating with MRA from Bank's Online and Mobile Banking applications." {

    !identifiers hierarchical

    model {
        // --- 1. Declare all Persons and external Software Systems first ---

        // Persons
        client = person "Customer" "Bank customer who wants to open a RA account."

        // External Software Systems
        ciam = softwareSystem "Ciam Identity Platform" "External Identity and Access Management (IAM) service for authentication."
        mmm = softwareSystem "MRA Platform" "Third-party platform for RA account management."
        ppp = softwareSystem "PPP Platform" "External platform for www/RA account storage."

        // Bank's Applications (Software Systems that are part of the bank's IT landscape but are peers to bank_systems)
        online_banking = softwareSystem "Online Banking Application" "Web application for customer banking services" {
            tags "Vendor"
        }
        mobile_banking = softwareSystem "Mobile Banking Application" "Native mobile application for customer banking services" {
            tags "Vendor"

        }

        // 2. Define the main Bank's Systems software system and nest its internal containers directly
        bank_systems = softwareSystem "Bank's Systems" "All systems within the Bank's enterprise." {
            // Vendor-managed containers
            core_banking = container "Core Banking System" "Manages core customer and account data (Vendor Managed)." "Mainframe/Legacy System" {
                tags "Vendor"
            }
            codeconnect_gateway = container "CodeConnect API Gateway" "Vendor-provided API gateway for core banking services." "API Gateway" {
                tags "Vendor"
            }

            // Bank-managed containers
            bank_api_gateway = container "Bank API Gateway" "Routes and secures API calls to internal bank services (Bank Managed)." "API Gateway" {
                tags "Bank"
            }
            robo_onboarding_ui = container "RA Onboarding UI" "Bank-built web component for customer data verification and SSO initiation (Bank Managed)." "Web Application" {
                tags "Bank"
            }
            customer_profile_service = container "Customer Profile Service" "Provides customer demographic, contact, and employment information (Bank Managed)." "Microservice" {
                tags "Bank"
            }
            account_service = container "Account Service" "Provides list of customer accounts for funding (Bank Managed)." "Microservice" {
                tags "Bank"
            }
        }


        // --- 3. Define all Relationships after all elements are declared ---
        client -> online_banking "1. Uses" "HTTPS"
        client -> mobile_banking "1. Uses" "HTTPS/Mobile Protocol"

        online_banking -> ciam "2. Authenticates User" "OpenID Connect/OAuth2"
        mobile_banking -> ciam "2. Authenticates User" "OpenID Connect/OAuth2"
        ciam -> bank_systems.bank_api_gateway "3. Provides Authentication Token/User Identity" "Internal API/Token Validation"

        online_banking -> bank_systems.robo_onboarding_ui "4. Launches (from dashboard banner)" "URL Redirect/IFrame"
        mobile_banking -> bank_systems.robo_onboarding_ui "4. Launches (from dashboard banner)" "URL Redirect/Webview"

        bank_systems.robo_onboarding_ui -> bank_systems.customer_profile_service "5. Fetches/Updates Customer Data (Demographics, Contact, Employment)" "HTTPS/REST API via Bank API Gateway"
        bank_systems.robo_onboarding_ui -> ciam "6. Initiates SSO for Marstone" "OpenID Connect/OAuth2"

        ciam -> mmm "7. Redirects Authenticated User with Identity" "OpenID Connect/OAuth2 Redirect"

        mmm -> bank_systems.bank_api_gateway "8. Calls (Pre-populate Customer Info)" "Bank API (HTTPS)"
        bank_systems.bank_api_gateway -> bank_systems.customer_profile_service "8a. Routes Request" "Internal API Call"
        bank_systems.customer_profile_service -> bank_systems.codeconnect_gateway "8b. Fetches Customer Data" "API Calls"
        bank_systems.codeconnect_gateway -> bank_systems.core_banking "8c. Routes to Core Banking" "Internal API Calls"

        mmm -> bank_systems.bank_api_gateway "9. Calls (Fetch Accounts for Funding)" "Bank API (HTTPS)"
        bank_systems.bank_api_gateway -> bank_systems.account_service "9a. Routes Request" "Internal API Call"
        bank_systems.account_service -> bank_systems.codeconnect_gateway "9b. Fetches Account Data" "API Calls"
        bank_systems.codeconnect_gateway -> bank_systems.core_banking "9c. Routes to Core Banking" "Internal API Calls"

        bank_systems.robo_onboarding_ui -> bank_systems.bank_api_gateway "10. Submits Verified Customer Data for Account Opening" "HTTPS/REST API"
        bank_systems.bank_api_gateway -> bank_systems.core_banking "10a. Validates/Stores Customer Data" "Internal API Calls"

        mmm -> ppp "11. Stores RA Account" "API Calls"
    }

    views {
        systemContext bank_systems mmm_integration "System Context Diagram for MRA Integration." {
            include *
            include client
            include mmm
            include ppp
            autoLayout
        }
        container bank_systems bank_containers "Container Diagram for MRA Integration." {
            include *
            include client
            include mmm
            include ppp
            autoLayout
        }

        // Styles block moved inside the views block as per user's environment requirement
        styles {
            element "Vendor" {
                background #90EE90
                color #000000
                shape Box
            }
            element "Bank" {
                background #007bff
                color #FFFFFF
                shape Box
            }
            element "Person" {
                shape Person
            }
        }
    }
}
