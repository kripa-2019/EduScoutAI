/*
  # Create courses table for project management courses

  1. New Tables
    - `courses`
      - `id` (uuid, primary key)
      - `title` (text, required) - Course title
      - `url` (text, required) - Course URL
      - `platform` (text, required) - Platform name (e.g., Coursera, Udemy)
      - `description` (text, required) - Course description
      - `created_at` (timestamptz, auto-generated) - Creation timestamp

  2. Security
    - Enable RLS on `courses` table
    - Add policies for:
      - Public read access (anyone can view courses)
      - Only authenticated admins can insert/update/delete courses
*/

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    url text NOT NULL,
    platform text NOT NULL,
    description text NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access"
    ON courses
    FOR SELECT
    TO public
    USING (true);

-- Create policy for admin insert access
CREATE POLICY "Allow admin insert"
    ON courses
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.jwt() ->> 'email' IN (
            'kripar@outlook.com'  -- Replace with actual admin email
        )
    );

-- Create policy for admin update access
CREATE POLICY "Allow admin update"
    ON courses
    FOR UPDATE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' IN (
            'kripar@outlook.com'  -- Replace with actual admin email
        )
    )
    WITH CHECK (
        auth.jwt() ->> 'email' IN (
            'kripar@outlook.com'  -- Replace with actual admin email
        )
    );

-- Create policy for admin delete access
CREATE POLICY "Allow admin delete"
    ON courses
    FOR DELETE
    TO authenticated
    USING (
        auth.jwt() ->> 'email' IN (
            'kripar@outlook.com'  -- Replace with actual admin email
        )
    );

-- Insert some initial courses data
INSERT INTO courses (title, url, platform, description) VALUES
    (
        'Project Management Fundamentals',
        'https://www.coursera.org/learn/project-management-foundations',
        'Coursera',
        'Learn the fundamentals of project management including project planning, scheduling, risk management, and team leadership.'
    ),
    (
        'Agile Project Management',
        'https://www.edx.org/learn/agile/introduction-to-agile-project-management',
        'edX',
        'Master Agile methodologies and learn how to implement Scrum, Kanban, and other Agile frameworks in your projects.'
    ),
    (
        'PMP Certification Preparation',
        'https://www.udemy.com/course/pmp-certification-prep',
        'Udemy',
        'Comprehensive preparation course for the Project Management Professional (PMP) certification exam.'
    );
