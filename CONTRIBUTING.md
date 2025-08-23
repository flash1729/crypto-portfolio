# Contributing to Crypto Portfolio App

Thank you for your interest in contributing to the Crypto Portfolio App! This document provides guidelines and instructions for contributing to the project.

## 🤝 How to Contribute

### Reporting Bugs 🐛

Before creating a bug report, please check if the issue already exists in our [Issues](https://github.com/yourusername/crypto-portfolio-app/issues) section.

When creating a bug report, please include:
- **Device and iOS version**
- **Steps to reproduce the issue**
- **Expected behavior**
- **Actual behavior**
- **Screenshots or screen recordings** (if applicable)

### Suggesting Features 💡

We welcome feature suggestions! Please:
- Check if the feature has already been requested
- Provide a detailed description of the feature
- Explain the use case and benefits
- Include mockups or sketches if possible

### Code Contributions 💻

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Follow the coding standards** (see below)
4. **Test your changes thoroughly**
5. **Commit with clear messages**: `git commit -m "Add: feature description"`
6. **Push to your branch**: `git push origin feature/your-feature-name`
7. **Create a Pull Request**

## 📝 Coding Standards

### Swift Style Guide
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and concise

### SwiftUI Best Practices
- Use `@State` for local view state
- Use `@ObservedObject` for external data sources
- Extract reusable components into separate files
- Follow the established component structure

### Code Organization
- Place new components in `Views/Components/`
- Add models to `Models/` directory
- Put business logic in ViewModels
- Use extensions for helper functions

### Commit Messages
Use clear, descriptive commit messages:
- `Add: new feature or component`
- `Fix: bug description`
- `Update: modification to existing feature`
- `Refactor: code structure improvements`
- `Docs: documentation updates`

## 🧪 Testing

Before submitting a PR:
- Test on multiple device sizes (iPhone SE, iPhone 15, iPhone 15 Plus)
- Verify both light and dark mode (if applicable)
- Test with different data scenarios
- Ensure no compilation warnings

## 📱 Development Setup

1. **Requirements**:
   - Xcode 15.0+
   - iOS 17.0+ deployment target
   - macOS 14.0+

2. **Setup**:
   ```bash
   git clone https://github.com/yourusername/crypto-portfolio-app.git
   cd crypto-portfolio-app
   open CryptoPortfolio_Assignment.xcodeproj
   ```

3. **Development Workflow**:
   - Create feature branch from `main`
   - Make changes in small, focused commits
   - Test thoroughly before pushing
   - Keep PR scope focused and manageable

## 🔍 Code Review Process

All submissions require review. We may ask for changes before merging:
- Code quality and style
- Performance considerations
- User experience impact
- Compatibility with existing features

## 📋 Pull Request Template

When creating a PR, please include:
- **Description**: What does this PR do?
- **Type**: Bug fix, feature, refactor, docs, etc.
- **Testing**: How was this tested?
- **Screenshots**: Visual changes (if applicable)
- **Breaking Changes**: Any breaking changes?

## 🎯 Priority Areas

We're particularly interested in contributions for:
- **Chart Interactions**: Improving smoothness and responsiveness
- **Performance Optimizations**: Faster rendering and animations
- **Accessibility**: VoiceOver support and accessibility features
- **Testing**: Unit tests and UI tests
- **Documentation**: Code comments and user guides

## ❓ Questions?

If you have questions about contributing:
- Check our [FAQ](docs/FAQ.md)
- Open a [Discussion](https://github.com/yourusername/crypto-portfolio-app/discussions)
- Contact the maintainers

## 🙏 Recognition

Contributors will be acknowledged in our README and release notes. Thank you for helping make this project better!

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
