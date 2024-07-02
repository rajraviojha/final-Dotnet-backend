# Start by specifying the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj file to the container
COPY WebApplication1.csproj .

# Restore NuGet packages
RUN dotnet restore

# Copy all files from the current directory to the container's working directory
COPY . .

# Build the application
RUN dotnet build -c Release -o /app/build

# Publish the application
RUN dotnet publish -c Release -o /app/publish

EXPOSE 80
EXPOSE 443

# Final stage to use the smaller runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
