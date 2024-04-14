---
title: "Introduction"
chapter: false
weight: 2
---

## Introduction to Jenkins

![DevOps](https://www.jenkins.io/images/logos/actor/256.png)



# What is Jenkins?

---

Jenkins is a **self-contained**, open source automation server which can be used to automate all sorts of tasks related to **building**, **testing**, and **delivering** or **deploying software**.

Jenkins can be installed through native system packages, `Docker`, or even run standalone by any machine with a **Java Runtime Environment (JRE)** installed.

It also allow you to automate your deployment starting from lower environment such as:

{{<mermaid align="center">}}
graph LR;
    A[DEV] --> B(QA) --> C[STAGING] --> D[PROD]
{{< /mermaid >}}


It allows you to define / create scripts by using <i>Groovy Scripts</i> to create logical workflow that you would use to automate your **build** / **testing** / **delivery** or **deployment**.
