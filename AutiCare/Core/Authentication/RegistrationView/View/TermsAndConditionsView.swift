//
//  TermsAndConditions.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct TermsAndConditionsView: View {
    private var terms:String = """
        AUTICARE
        TERMS & CONDITIONS
        Effective Date: July 04, 2025
        These Terms and Conditions [“Terms”] govern your access to and use of the Auticare mobile application [the “App”], owned and operated by Auticare [“we,” “us,” or “our”]. By accessing or using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree with any part of these Terms, you must not use the App.
        
        1. Eligibility and User Requirements
        
        1.1 Age Restriction
        You must be at least 18 years old to create an account and use the App. By registering, you confirm that you meet this age requirement.
        1.2 Legal Authority
        You agree that you are legally authorized to submit data on behalf of any child for whom you are using the App. You must be a parent, guardian, or caregiver with lawful authority to provide such information.
        
        2. Account Registration and Security

        2.1 Account Creation
        To use certain features of the App, you must create an account. You agree to provide accurate, current, and complete information during registration and to keep your information updated.
        2.2 Account Security
        You are solely responsible for safeguarding your login credentials and all activity under your account. You agree to notify us immediately of any unauthorized use or security breach.
        
        3. User-Generated Content

        3.1 Community Uploads
        You may upload images to the App’s community feed. By doing so, you grant Auticare a non-exclusive, royalty-free, worldwide license to use, reproduce, and display such content within the App.
        3.2 Content Ownership and Rights
        You affirm that you own or have the necessary rights to the content you upload and that such content does not violate any laws or third-party rights.
        3.3 Content Moderation
        We reserve the right to review, remove, or disable access to any content that we, in our sole discretion, deem inappropriate or in violation of these Terms.
        
        4. Educational Content and Usage Restrictions

        4.1 Intellectual Property of Materials
        All educational materials, including videos, documents, and assessments, are the intellectual property of Auticare or its licensors and are protected by applicable copyright and trademark laws.
        4.2 Permitted Use
        You are granted a limited, non-transferable, non-exclusive license to access and view learning content for personal, non-commercial, educational purposes only.
        4.3 Prohibited Use
        You may not reproduce, download, distribute, modify, or use any content or media outside the App without express written permission from Auticare.
        
        5. Medical Disclaimer

        5.1 Informational Use Only
        The App is intended to support autism screening and educational development. It uses tools such as the ISAA [Indian Scale for Assessment of Autism] for structured assessments but does not offer medical advice or diagnosis.
        5.2 Professional Consultation Required
        You agree to consult a licensed medical or mental health professional for any clinical evaluation, diagnosis, or treatment decision. We do not assume liability for decisions made based on App usage.
        
        6. Acceptable Use Policy

        6.1 Lawful Conduct
        You agree to use the App in accordance with all applicable laws and regulations.
        6.2 Prohibited Conduct
        You must not:
        Upload or share unlawful, offensive, or harmful content
        Harass, threaten, or abuse other users
        Infringe on copyrights, trademarks, or other intellectual property
        Use the App for commercial solicitation
        Attempt to reverse engineer, disrupt, or gain unauthorized access to the App or its infrastructure
        
        7. Termination and Suspension

        7.1 Termination by Auticare
        We reserve the right to suspend, restrict, or terminate your access to the App, without prior notice, if we believe you have violated these Terms, applicable laws, or community standards.
        7.2 Termination by User
        You may terminate your account at any time by contacting us. Termination does not affect any obligations incurred prior to termination.
        
        8. Privacy and Data Protection

        8.1 Data Collection and Use
        Your use of the App is governed by our Privacy Policy, which explains how we collect, process, and protect your personal information.
        8.2 Consent
        By using the App, you consent to the collection and use of your data, including assessment data related to children, as outlined in the Privacy Policy.
        
        9. Intellectual Property Rights

        9.1 Ownership
        All software, content, design, and branding on the App are the exclusive property of Auticare or its licensors.
        9.2 Restrictions
        You may not copy, distribute, modify, or use any part of the App or its materials for commercial or public purposes without our express written consent.
        
        10. Indemnification
        
        You agree to defend, indemnify, and hold harmless Auticare and its affiliates, officers, employees, and agents from and against any claims, liabilities, damages, costs, and expenses, including reasonable legal fees, arising from:
        Your use or misuse of the App
        Your violation of these Terms or applicable laws
        Your infringement of third-party rights or intellectual property
        
        11. Disclaimer and Limitation of Liability

        11.1 Disclaimer of Warranties
        The App is provided on an “as is” and “as available” basis without warranties of any kind, either express or implied, including but not limited to merchantability, fitness for a particular purpose, or non-infringement.
        11.2 Limitation of Liability
        To the maximum extent permitted by law, Auticare shall not be liable for any indirect, incidental, consequential, punitive, or exemplary damages arising from or related to your use of the App, even if we have been advised of the possibility of such damages.
        
        12. Dispute Resolution and Arbitration

        12.1 Governing Law
        These Terms shall be governed by and construed in accordance with the laws of India, without regard to conflict of law principles.
        12.2 Arbitration
        Any dispute, claim, or controversy arising out of or in connection with these Terms shall be resolved by binding arbitration in accordance with the Indian Arbitration and Conciliation Act, 1996.
        The seat and venue of arbitration shall be New Delhi, India
        The arbitration shall be conducted in English
        The award shall be final and binding upon the parties
        
        13. Severability and Waiver

        13.1 Severability
        If any provision of these Terms is held to be invalid or unenforceable, the remaining provisions will remain in full force and effect.
        13.2 No Waiver
        Our failure to enforce any right or provision of these Terms shall not be deemed a waiver of such right or provision.
        
        14. Force Majeure
        
        We shall not be held liable for any failure or delay in performance caused by circumstances beyond our reasonable control, including but not limited to natural disasters, pandemics, governmental restrictions, war, cyberattacks, or system failures.
        
        15. Modifications to Terms or Services
        
        We reserve the right to modify these Terms or any part of the App at any time. Any changes will be communicated through the App or by email. Continued use of the App after such changes constitutes your acceptance of the revised Terms.
        
        16. Contact Information
        
        If you have any questions, concerns, or feedback regarding these Terms, please contact:
        Auticare Support Team
        Email: [Insert Contact Email]

        """
    var body: some View {
        ScrollView{
            Text(terms)
        }
        .navigationTitle("Terms & Conditions")
    }
}

#Preview {
    TermsAndConditionsView()
}
