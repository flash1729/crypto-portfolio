//
//  Indian Currency Formatting Test Examples
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 23/08/25.
//

/*
Test values and their expected formatted outputs:

1. 1234.56 → "₹ 1,234.56"
2. 12345.67 → "₹ 12,345.67"
3. 123456.78 → "₹ 1,23,456.78"
4. 1234567.89 → "₹ 12,34,567.89"
5. 12345678.90 → "₹ 1,23,45,678.90"
6. 7562502.14 → "₹ 75,62,502.14"
7. 179102.50 → "₹ 1,79,102.50"
8. 465006.44 → "₹ 4,65,006.44"

Indian numbering system:
- First comma after 3 digits from right
- Subsequent commas after every 2 digits
- This follows the lakh (1,00,000) and crore (1,00,00,000) system
*/
