FROM 975050008954.dkr.ecr.eu-west-1.amazonaws.com/home-assignment-yotam:latest

# Copy the tests directory
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the tests
CMD ["pytest"]
