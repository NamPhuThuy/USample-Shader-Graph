<a id="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/NamPhuThuy/Unity-Initial">
    <img src="images/avatar.png" alt="Logo" width="200">
  </a>

<h3 align="center">README-Template</h3>

  <p align="center">
    <a href="https://github.com/NamPhuThuy/Unity-Initial">View Demo</a>
    ·
    <a href="https://github.com/NamPhuThuy/Unity-Initial/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/NamPhuThuy/Unity-Initial/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage-examples">Usage examples</a></li>
    <li><a href="#todo">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Some learning sources:
- https://danielilett.com/2023-09-26-tut7-3-intro-to-shader-graph/
  - Shader Graph Basics: https://danielilett.com/2023-09-26-tut7-3-intro-to-shader-graph/
  - Shader Code Basics: https://danielilett.com/2025-10-15-tut10-01-your-first-shader/
  - 10 Shaders Explained Quickly: https://danielilett.com/2023-04-07-tut6-5-10-shaders-quickly/
  - URP Series: https://danielilett.com/2020-03-21-tut5-1-urp-cel-shading/
- https://github.com/DeGGeD/ShaderStory


<p align="right">(<a href="#readme-top">back to top</a>)</p>

| Scenario | RenderType | Queue | Why? | 
| :--- | :--- | :--- | :--- | 
| Solid Object | "Opaque" | "Geometry" (2000) | Drawn first to write to the depth buffer. Efficient. | 
| Cutout (Fence/Leaf) | "TransparentCutout" | "AlphaTest" (2450) | Drawn after solids but before true transparency. | 
| Glass / Ghost | "Transparent" | "Transparent" (3000) | Drawn last (back-to-front) so they blend over solids. | 
| UI / Overlay | "Overlay" | "Overlay" (4000) | Drawn on top of everything else. |

### Built With


<!-- GETTING STARTED -->
## Getting Started

Instructions to setup this project locally.

### Prerequisites

### Installation

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact
[![Facebook][facebook-shield]][facebook-url]  
[![Github][github-shield]][github-url]  
[![Itch][itch-shield]][itch-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>






<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/NamPhuThuy/Unity-Initial.svg?style=for-the-badge
[contributors-url]: https://github.com/NamPhuThuy/Unity-Initial/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/NamPhuThuy/Unity-Initial.svg?style=for-the-badge
[forks-url]: https://github.com/NamPhuThuy/Unity-Initial/network/members
[stars-shield]: https://img.shields.io/github/stars/NamPhuThuy/Unity-Initial.svg?style=for-the-badge
[stars-url]: https://github.com/NamPhuThuy/Unity-Initial/stargazers
[issues-shield]: https://img.shields.io/github/issues/NamPhuThuy/Unity-Initial.svg?style=for-the-badge
[issues-url]: https://github.com/NamPhuThuy/Unity-Initial/issues
[license-shield]: https://img.shields.io/github/license/NamPhuThuy/Unity-Initial.svg?style=for-the-badge
[license-url]: https://github.com/NamPhuThuy/Unity-Initial/blob/main/LICENSE

<!-- Contact -->
[facebook-shield]: https://img.shields.io/badge/-Facebook-blue.svg?style=for-the-badge&logo=facebook&colorB=3842c6
[facebook-url]: https://www.facebook.com/namphuthuy957
[github-shield]: https://img.shields.io/badge/-Github-blue.svg?style=for-the-badge&logo=github&colorB=252525
[github-url]: https://github.com/NamPhuThuy
[itch-shield]: https://img.shields.io/badge/-itch.io-blue.svg?style=for-the-badge&logo=itch.io&colorB=f5f5f5
[itch-url]: https://namphuthuy.itch.io/


<!-- Mock Up -->
[product-screenshot]: images/avatar.png

<!-- Tech Stack -->
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
[Unity.com]: https://img.shields.io/badge/Unity-61DBFB?style=for-the-badge&logo=unity&logoColor=white&labelColor=black&color=black
[Unity-url]: https://unity.com/
[CSharp.com]: https://img.shields.io/badge/C%23-61DBFB?style=for-the-badge&logo=c%23&logoColor=white&labelColor=magenta&color=purple

[CSharp-url]: https://learn.microsoft.com/en-us/dotnet/csharp/
