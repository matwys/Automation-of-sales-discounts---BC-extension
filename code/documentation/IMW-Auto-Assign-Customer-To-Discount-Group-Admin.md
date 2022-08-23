# Customer Disc. Group Automation (Admin)

## Turning on functionality

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Sales & Receivables Setup**. Choose the related link.
2. In **"CDG Automation"** Group find field **CDGA Enabled** and turn it on.

> [!Note]
>
> Value of **CDGA Validity Period** must be greater or equal **1D**.
>
> Value of **CDGA Sales Period** bust be less or equal **-1D**.

## Set the requirement for Customer Disc. Group Automation

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **CDGA Thresholds Setup**. Choose the related link.
2. Select the setup for Customer Disc. Group or create a new one.
3. **Customer Disc. Group Code** field represents **Customer Disc. Groups**.
4. **Threshold Sales Amount (LCY)** field is used for set threshold that must be met for assign to that group. All threshold amount must have different value.
5. After changes find action **Release** (Actions -> Release -> Release) and use it.

> [!Note]
>
> User can make changes when **CDGA Threshold Setup Status** in "CDG Automation" in **Sales & Receivables Setup** is *Open*. When **CDGA Threshold Setup Status** is *Released* use action **Open** (Actions -> Release -> Open) in **CDGA Thresholds Setup**.

## Auto assign Customer to discount group

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Customers**. Choose the related link.
2. Choose **Customer** from the list and open **Customer Card**.
3. When functionality is enable it should not be possible to manually manipulate with **Customer Disc. Group**.
4. You can use action to auto assign this Customer to discount group. Find action **CDGA Update Customer** (Related -> Prices and Discounts ->CDGA Update Customer) and run it.
5. See Customer is assigned to discount group and fields **Customer Disc. Group**, **CDGA Valid To**, **CDGA Changed By** and **CDGA Changed Date** have been changed.

> [!Note]
>
> New created Customer will be auto assigned to **Customer Disc. Group**.

## Auto assign all Customers to discount group

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **CDGA Thresholds Setup**. Choose the related link.
2. Find action **CDGA Update All Customers** and rut it.
3. Request page **CDGA Update All Customers** show up. In this page is only one field **CDGA Only With Invalid Assigned**. If it is *turned on* Customers with invalid assigned will be assigned.
If it is *turned off* all Customers will be assigned.

> [!Note]
>
> This action is available when **functionality** is *turned on* and **status** is *released*.

## Create new Sales Document

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Sales Order**. Choose the related link.
2. Set Customer in **Customer Name** field. When Customer has invalid assigned this page show error. When Customer has valid assigned, all should work correctly.

> [!Note]
>
> When sales document is going to be created from action in **Customer Card** page. Error will show up when Customer has invalid assigned.
>
> All old document with customer with invalid assigned will work correctly.

## CDGA Change Log

### Search CDGA Change Log in tell me what you want to do

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **CDGA Change Log**. Choose the related link.
2. CDGA Change Log page show up.

### From Customer Card page

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Customers**. Choose the related link.
2. Choose **Customer** from the list and open **Customer Card**.
3. Find action **CDGA Change Log** (Related -> History -> CDGA Change Log) and run it.
4. CDGA Change Log page show up. List is filtered by *Customer No.*.
