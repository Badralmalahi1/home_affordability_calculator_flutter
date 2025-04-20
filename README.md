# Home Affordability Calculator

## Project Overview
This Flutter app helps users estimate the home price they can afford based on their monthly income, debt, and down payment. It also allows users to search for homes on Zillow using the calculated price and their ZIP code.

## Features
- **Home Affordability Estimator**: Calculates home price based on DTI ratio.
- **Zillow Integration**: Explore homes on Zillow based on affordability.
- **History**: View and manage previous calculations.

## UML Class Diagram
```mermaid
classDiagram
    class HomeAffordabilityProfile {
        +double income
        +double debt
        +double downPayment
        +double _calculatePriceFromDTI(dtiRatio)
        +double get conservativePrice
        +double get flexiblePrice
    }

    HomeAffordabilityProfile : +calculatePriceFromDTI(dtiRatio)
    HomeAffordabilityProfile : +conservativePrice
    HomeAffordabilityProfile : +flexiblePrice
