# WhatsNext Vision Motors – Salesforce CRM

WhatsNext Vision Motors is a Salesforce-based CRM solution designed to streamline vehicle sales, dealer management, customer management, vehicle orders, test drives, and service requests.

The project uses Salesforce DX, Apex, Record-Triggered Flows, Batch Apex, Scheduled Apex, Reports, Dashboards, and Salesforce metadata to automate vehicle ordering and dealership workflows.

## Prerequisites

Before you start, make sure you have:

- **Salesforce CLI** - Install Salesforce CLI for deploying and retrieving Salesforce metadata.
- **VS Code with Salesforce Extension Pack** - Recommended for Salesforce development and metadata management.
- **Salesforce Developer Edition Org** - A Salesforce development org for configuring and testing the application.
- **Git and GitHub** - Used for source control, version management, and project collaboration.
- **Salesforce DX Project** - The project follows the Salesforce DX source-driven project structure.

## Project Structure

The project follows the Salesforce DX structure:

- **`force-app/main/default/`** - Contains Salesforce metadata such as Apex classes, triggers, custom objects, fields, flows, and applications.
- **`force-app/main/default/classes/`** - Contains Apex classes for business logic, batch processing, and scheduling.
- **`force-app/main/default/triggers/`** - Contains Apex triggers.
- **`force-app/main/default/objects/`** - Contains custom objects, fields, relationships, and list views.
- **`force-app/main/default/flows/`** - Contains Salesforce Flow automation.
- **`force-app/main/default/applications/`** - Contains the WhatsNext Vision Motors Lightning application.
- **`manifest/`** - Contains package manifests used for selective metadata retrieval and deployment.
- **`sfdx-project.json`** - Defines Salesforce DX project configuration and package directories.

## Custom Objects

The project contains the following custom Salesforce objects:

- **Vehicle__c** - Stores vehicle information, pricing, stock quantity, model, dealer, and availability.
- **Vehicle_Dealer__c** - Stores authorized dealer information including location, contact details, and dealer code.
- **Vehicle_Customer__c** - Stores customer information such as name, email, phone, address, and preferred vehicle type.
- **Vehicle_Order__c** - Tracks customer vehicle orders and their status.
- **Vehicle_Test_Drive__c** - Manages vehicle test-drive bookings and schedules.
- **Vehicle_Service_Request__c** - Manages customer vehicle service requests.

## Key Features

The WhatsNext Vision Motors CRM provides:

- **Automatic Dealer Assignment** - Assigns a dealer to vehicle orders based on customer and dealer location.
- **Vehicle Stock Management** - Maintains vehicle inventory and stock quantities.
- **Out-of-Stock Validation** - Prevents vehicle orders from being confirmed when stock is unavailable.
- **Automatic Order Confirmation** - Confirms pending orders when vehicle stock becomes available.
- **Automatic Stock Reduction** - Decreases vehicle stock when an order is confirmed.
- **Test Drive Management** - Allows scheduled test drives to be managed through Salesforce.
- **Test Drive Email Reminders** - Sends reminder emails before scheduled test drives.
- **Order Confirmation Emails** - Sends confirmation emails when vehicle orders are confirmed.
- **Batch Processing** - Processes pending vehicle orders when stock becomes available.
- **Scheduled Processing** - Automatically runs batch processing on a scheduled basis.
- **Reports and Dashboards** - Provides visibility into inventory, orders, test drives, and service requests.

## Salesforce Automation

The project uses Salesforce automation to manage business processes.

### Auto Assign Dealer Flow

Automatically assigns a dealer to a vehicle order based on the customer's location.

```text
Vehicle Order
      ↓
Get Customer Information
      ↓
Get Nearest Dealer
      ↓
Assign Dealer to Order
      ↓
End